module RailsAdmin
  module Config
    module Actions
      class AddTraineeToCourse < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-plus"
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :pjax? do
          false
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :controller do
          proc do
            @course = object

            if request.post?
              user_param_ids = params[:course][:user_ids].map(&:to_i).reject{|id| id == 0}
              user_course_ids = object.users.pluck :id
              user_remove_ids = user_course_ids - user_param_ids
              user_add_ids = user_param_ids - user_course_ids
              user_add_ids.each do |user_id|
                object.user_courses.create user_id: user_id, leader_id: current_user.id
              end

              user_remove_ids.each do |user_id|
                user_course = UserCourse.find_by course_id: object.id, user_id: user_id
                user_course.destroy
              end
              flash[:success] = t "admin.actions.updated"
              redirect_to edit_course_path(Course, @course)
            end
          end
        end
      end
    end
  end
end
