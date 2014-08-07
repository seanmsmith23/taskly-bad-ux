class AddAssignedToColumnsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_to_2, :string
    add_column :tasks, :assigned_to_3, :string
    add_column :tasks, :assigned_to_4, :string
  end
end
