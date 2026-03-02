class AddNullConstraintsToTasks < ActiveRecord::Migration[8.1]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :completed, false
  end
end
