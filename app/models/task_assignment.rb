# frozen_string_literal: true

class TaskAssignment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :user_id, uniqueness: { scope: :task_id }
  validate :user_is_not_owner

  private

  def user_is_not_owner
    return unless task && task.user_id == user_id

    errors.add(:user_id, "cannot assign task owner to their own task")
  end
end
