class ChangeAssigneeIdNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :assignee_id, true
  end
end
