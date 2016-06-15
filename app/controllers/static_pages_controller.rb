class StaticPagesController < ApplicationController
  def home
    @count_course_active = Course.progress.count
    @count_course = Course.count
    @count_user_inprogress = UserCourse.course_progress.count
    @count_user = User.count

    @user_progress_name = UserProgress.pluck :name
    @user_progress_total = UserProgress.includes(:profiles)
      .map{|user_progress| user_progress.profiles.size}

    @courses = Course.all
  end

  def help
  end

  def contact
  end
end
