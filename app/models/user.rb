# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy
  has_many :task_assignments, dependent: :destroy
  has_many :assigned_tasks, through: :task_assignments, source: :task
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true

    def accessible_tasks
        Task.accessible_by(self).ordered
    end
end
