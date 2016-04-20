class UserTask < ActiveRecord::Base
  include PublicActivity::Model

  ATTRIBUTES_PARAMS = [
    :spent_time, :estimated_time, :redmine_task_id, :status, :progress,
      :user_id, :user_subject_id, :task_id
  ]

  has_many :activities, as: :trackable, class_name: "PublicActivity::Activity",
    dependent: :destroy

  belongs_to :task
  belongs_to :user_subject
  belongs_to :user

  delegate :id, :name, :image_url, :description, to: :task, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :description, :content, to: :task, prefix: true, allow_nil: true

  before_create :init_relation_user
  after_update :subject_progress

  def nil_master?
    task.task_master_id.nil?
  end

  def create_by_trainee?
    task.create_by_trainee
  end

  def subject_in_progress?
    user_subject.progress?
  end

  def assignable_task?
    nil_master? && create_by_trainee? && !user_subject.finish?
  end

  def assigned?
    assignable_task? && user_id.present?
  end

  private
  def init_relation_user
    self.user_id = self.user_subject.user_id
  end

  def subject_progress
    if self.status == Settings.tasks.statuses.closed
      total_time = self.user_subject.total_time_task_closed
      total_time += self.estimated_time.to_f
      self.user_subject.update_attributes(total_time_task_closed: total_time, progress: total_time * 100 /
        (self.user_subject.during_time * Settings.hours_working_day))
    end
  end
end
