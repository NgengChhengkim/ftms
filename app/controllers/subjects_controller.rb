class SubjectsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :course, only: [:index, :show]
  load_and_authorize_resource :subject, only: :show

  before_action :load_course, only: :update
  before_action :check_status, only: :update
  before_action :check_status_subject, only: :update

  def index
    @user_subjects = UserSubject.load_user_subject(current_user, @course)
  end

  def show
    @task_masters = @subject.task_masters
    @course_subject = CourseSubject.find_by course_id: @course.id,
      subject_id: @subject.id
    @user_subjects = @course_subject.user_subjects
    @user_subject = @course_subject.user_subjects.find_by user: current_user
    @unassign_tasks = @course_subject.tasks.not_assigned_trainee
  end

  private
  def load_course
    @user_subject = UserSubject.find params[:subject_id]
    @user_course = @user_subject.user_course
  end

  def check_status
    redirect_to :back unless params[:status] == Settings.finish
  end

  def check_status_subject
    redirect_to :back unless @user_subject.progress?
  end
end
