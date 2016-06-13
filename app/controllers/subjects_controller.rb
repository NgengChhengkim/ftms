class SubjectsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :user_course, only: [:show]
  load_and_authorize_resource :subject, only: :show

  before_action :load_course, only: :update
  before_action :check_status, only: :update
  before_action :check_status_subject, only: :update

  def show
    @task_masters = @subject.task_masters
    @course_subject = CourseSubject.includes(:tasks,
      user_subjects: [course: [:users], user_tasks: :task])
      .find_by course_id: @user_course.course_id, subject_id: @subject.id

    @user_subjects = @course_subject.user_subjects
    @user_subject = @user_subjects.find{|user_subject| user_subject.user_id == @user_course.user_id}

    users = @user_subject.course.users
    @trainers = users.trainers
    @trainees = users.trainees
    @trainees_show = @trainees.limit Settings.number_member_show
    @count_member = @user_subjects.size - Settings.number_member_show

    @user_tasks = @user_subject.user_tasks
    @number_of_task = @user_tasks.size

    @task_statuses = UserTask.statuses
    @task_statuses.each do |key, value|
      instance_variable_set "@number_of_task_#{key}", @user_tasks.send(key).size
    end
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
