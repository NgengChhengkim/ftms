class Admin::CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :load_subjects, only: [:new, :create, :edit]

  def index
    if current_user.is_admin?
      @courses = @courses.normal.recent
    else
      @courses = current_user.courses
    end
  end

  def new
    @course = Course.new parent_id: params[:parent_id]
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = flash_message "created"
      redirect_to admin_courses_path
    else
      flash[:failed] = flash_message "not created"
      render :new
    end
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = flash_message "updated"
      redirect_to admin_courses_path
    else
      flash[:failed] = flash_message "not updated"
      render :edit
    end
  end

  def show
    @course_subjects = @course.course_subjects
    @users = @course.users
    @roles = Role.not_admin
  end

  def destroy
    if @course.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not deleted"
    end
    redirect_to :back
  end

  private
  def course_params
    params.require(:course).permit :name, :description, :start_date,
      :end_date, :parent_id, subject_ids: []
  end

  def load_subjects
    @subjects = Subject.all
  end
end
