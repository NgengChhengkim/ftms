class UserTasksController < ApplicationController
  load_and_authorize_resource
  before_action :load_user_subject_course, only: :update

  def create
    if @user_task.save
      flash[:success] = flash_message "created"
    else
      flash[:failed] = flash_message "not created"
    end
    redirect_to :back
  end

  def update
    if @user_task.update_attributes user_task_params
      flash[:success] = flash_message "updated"
      redirect_to course_user_subject_path @user_course, @user_subject
    else
      flash[:failed] = flash_message "not updated"
      render :edit
    end
  end

  private
  def user_task_params
    params.require(:user_task).permit UserTask::ATTRIBUTES_PARAMS
  end

  def load_user_subject_course
    @user_subject = @user_task.user_subject
    @user_course = @user_task.user_subject.course
  end
end
