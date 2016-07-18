class Admin::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :load_data, except: [:index, :show, :destroy]
  before_action :load_breadcrumb_edit, only: [:edit, :update]
  before_action :load_breadcrumb_new, only: [:new, :create]

  def index
    respond_to do |format|
      format.html {add_breadcrumb_index "users"}
      format.json {
        render json: UsersDatatable.new(view_context)
      }
    end
  end

  def new
    build_profile
  end

  def create
    if @user.save
      flash[:success] = flash_message "created"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    build_profile unless @user.profile
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = flash_message "updated"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:alert] = flash_message "not_deleted"
    end
    redirect_to admin_users_path
  end

  def show
    add_breadcrumb_path "users"

    @activities = PublicActivity::Activity.user_activities(@user.id).recent.limit(20).decorate
    @user_courses = @user.user_courses
    @finished_courses = @user_courses.course_finished
    @inprogress_course = @user_courses.course_progress.last

    if @inprogress_course
      @user_subjects = @inprogress_course.user_subjects
      statistic_task_of_user
    end

    @note = Note.new
    @notes = Note.load_notes @user, current_user

    add_breadcrumb @user.name
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def load_data
    datas = [Role, University, ProgrammingLanguage, Status, UserType]
    datas.each do |data|
      instance_variable_set "@#{data.table_name}", data.all
    end
    @trainers = User.trainers
  end

  def load_breadcrumb_edit
    add_breadcrumb_path "users"
    add_breadcrumb @user.name, admin_user_path(@user)
    add_breadcrumb_edit "users"
  end

  def load_breadcrumb_new
    add_breadcrumb_path "users"
    add_breadcrumb_new "users"
  end

  def build_profile
    @user.build_profile
  end
end
