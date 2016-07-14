class CoursesDatatable
  include AjaxDatatablesRails::Extensions::Kaminari

  delegate :params, :link_to, to: :@view

  def initialize view
    @view = view
  end

  def as_json options = {}
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: courses.total_count,
      iTotalDisplayRecords: courses.total_count,
      aaData: data
    }
  end

  private
  def data
    courses.each_with_index.map do |course, index|
      [
        course.id,
        link_to(course.name, @view.admin_course_path(course)),
        course.load_trainers.map do |trainer|
          link_to(@view.avatar_user_tag(trainer, "profile-user",
          Settings.image_size_20), @view.admin_user_path(trainer),
          title: trainer.name)
        end,
        course.status
      ]
    end
  end

  def courses
    @courses ||= fetch_courses
  end

  def fetch_courses
    current_user = @view.current_user
    current_courses = current_user.is_admin? ? Course : current_user.courses
    courses = current_courses.order("#{sort_column} #{sort_direction}")
      .where("name like :search", search: "%#{params[:sSearch]}%")
      .per_page_kaminari(page).per per_page

    if params[:sSearch_3].present?
      courses = courses.where "status = :search", search: "#{params[:sSearch_3]}"
    end
    courses
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
