class AddAssignedColumnstoTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_to, :string
  end
end
