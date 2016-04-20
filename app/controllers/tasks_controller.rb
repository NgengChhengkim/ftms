class TasksController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :course_subject
  before_action :add_task_info, only: [:create]

  def create
    if @task.save
      flash[:success] = flash_message "created"
    else
      flash[:failed] = flash_message "not_created"
    end
    redirect_to :back
  end

  def update
    if @task.update_attributes task_params
      flash[:success] = flash_message "updated"
    else
      flash[:failed] = flash_message "not_updated"
    end
    redirect_to :back
  end

  private
  def task_params
    params.require(:task).permit Task::ATTRIBUTES_PARAMS
  end

  def add_task_info
    @task.create_by_trainee = current_user.is_trainee?
    @task.owner = current_user
    @task.course_subject = @course_subject
  end
end
