class AddIndexToTasksCompleted < ActiveRecord::Migration[8.1]
  def change
    add_index :tasks, :completed
  end
end
