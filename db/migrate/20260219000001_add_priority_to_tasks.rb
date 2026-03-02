# frozen_string_literal: true

class AddPriorityToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :priority, :integer, default: 0, null: false
    add_index :tasks, [ :user_id, :priority ]
  end
end
