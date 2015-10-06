module RailsAdmin
  module Config
    module Actions
      class EditCourse < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-pencil"
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :controller do
          proc do
            @supervisor = User.supervisor
            @subjects = Subject.all
            @trainees = (User.free_trainees << object.users).flatten!.sort
            if request.post?
              course_params = params.require(:course).permit :name, :description
              if object.update_attributes course_params
                flash[:success] = t "admin.actions.updated"
                redirect_to show_path "course", object
              else
                render "edit_course"
                flash[:danger] = t "admin.actions.not_updated"
              end
            end
          end
        end
      end
    end
  end
end
