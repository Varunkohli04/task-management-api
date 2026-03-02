class AddDefaultToTasksCompleted < ActiveRecord::Migration[8.1]
  def change
    change_column_default :tasks, :completed, false
  end
end
