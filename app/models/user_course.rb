class UserCourse < ActiveRecord::Base
  include PublicActivity::Model
  include InitUserSubject

  after_create :create_user_subjects_when_assign_new_user

  tracked only: [:create, :destroy],
    owner: ->(controller, model) {controller.current_user},
    recipient: ->(controller, model) {model && model.course},
    params: {
      user: proc {|controller, model| model.user}
    }
  belongs_to :user
  belongs_to :supervisor, class_name: User.name,
                          foreign_key: :supervisor_id
  belongs_to :leader, class_name: User.name,
                      foreign_key: :leader_id
  belongs_to :course
  belongs_to :supervising_course, class_name: Course.name,
                                  foreign_key: :course_id
  belongs_to :leading_course, class_name: Course.name,
                              foreign_key: :course_id

  has_many :user_subjects, dependent: :destroy

  scope :actived, ->{where active: true}
  scope :trainer_user_course, ->{where(user_id: Role.find_by(name: "trainer").users)}

  private
  def create_user_subjects_when_assign_new_user
    create_user_subjects [self], course.course_subjects, course_id, false
  end
end
