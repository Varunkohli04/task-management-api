# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, inverse_of: :tasks
  has_many :task_assignments, dependent: :destroy, inverse_of: :task
  has_many :assignees, through: :task_assignments, source: :user
  has_many :comments, dependent: :destroy, inverse_of: :task
  validates :title, presence: true
  scope :ordered, -> { order(priority: :asc, created_at: :asc) }
  # scope :ordered, -> {
  #   select("tasks.*, CASE WHEN priority = 0 THEN 1 ELSE 0 END AS priority_order")
  #     .order("priority_order ASC")
  #     .order(priority: :asc)
  #     .order(created_at: :desc)
  # }

  # scope :ordered, -> {
  # order(Arel.sql("CASE WHEN tasks.priority = 0 THEN 1 ELSE 0 END ASC"))
  #   .order(tasks: { priority: :asc })
  #   .order(tasks: { created_at: :desc })
  # }

  scope :owned_by, ->(user) { left_joins(:task_assignments).where(user: user) }
  scope :assigned_to, ->(user) { left_joins(:task_assignments).where(task_assignments: { user_id: user.id }) }
  scope :accessible_by, lambda { |user|
    return none unless user
    owned_by(user).or(assigned_to(user)).distinct
  }
end