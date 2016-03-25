class UserCoursesController < ApplicationController
  load_and_authorize_resource

  def show
    @course = @user_course.course
    @course_subjects = @user_course.user_subjects
    @users = @course.users
    @roles = Role.not_admin
  end
end
