class Admin::AllocatePermissionsController < ApplicationController
  load_and_authorize_resource :role

  def edit
    add_breadcrumb_path "roles"
    add_breadcrumb @role.name
    add_breadcrumb_role_allocate_permissions
    add_breadcrumb_edit "roles"
  end

  def update
    if @role.update_attributes role_params
      flash[:success] = flash_message "updated"
    else
      flash[:danger] = flash_message "not updated"
    end
    redirect_to :back
  end

  private
  def role_params
    params.require(:role).permit Role::ATTRIBUTES_PARAMS
  end
end
