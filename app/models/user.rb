class User < ActiveRecord::Base

  QUERY = "id NOT IN (SELECT user_id
    FROM user_courses, courses WHERE user_courses.course_id = courses.id
    AND (courses.status = 0 OR courses.status = 1)
    AND courses.id <> :course_id) AND role_id = 3"

  belongs_to :trainer, class_name: User.name, foreign_key: :trainer_id
  belongs_to :role

  has_many :user_courses, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :course_subjects, through: :user_subjects
  has_many :tasks, through: :user_tasks
  has_one :profile
  has_one :evaluation
  has_many :trainees, class_name: User.name

  validates :name, presence: true, uniqueness: true
  validates_confirmation_of :password

  devise :database_authenticatable, :rememberable, :trackable, :validatable

  scope :available_of_course, ->course_id{where QUERY, course_id: course_id}
  scope :find_by_role, -> role{where role: role}
  scope :trainers, ->{joins(:role).where("roles.name = 'trainer'")}

  after_create :create_user_profile, if: :is_trainee?

  def total_done_tasks user, course
    done_tasks = UserSubject.load_user_subject(user.id, course.id).map(&:user_tasks).flatten.count
  end

  def owner_course course
    return course.user_courses.find_by(supervisor_id: self.id) ? true :false
  end

  def leader_course course
    return course.user_courses.find_by(leader_id: self.id) ? true :false
  end

  def is_admin?
    self.role.name == "admin"
  end

  def is_trainee?
    role.name == "trainee"
  end

  private
  def password_required?
    new_record? ? super : false
  end

  def create_user_profile
    create_profile user_id: id
  end
end
