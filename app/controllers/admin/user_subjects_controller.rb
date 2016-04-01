class Admin::UserSubjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_data, only: :update

  def update
    @user_subject.update_status
    respond_to do |format|
      format.js
    end
  end

  private
  def load_data
    @course_subject = CourseSubject.find params[:course_subject_id]
    @subject = @course_subject.subject
    @course = @course_subject.course
    @user_subjects = @course_subject.user_subjects
    @unassign_tasks = @course_subject.tasks.not_assigned_trainee
    @user_subjects_not_finishs = @user_subjects.not_finish(@user_subjects.finish)
  end
end
