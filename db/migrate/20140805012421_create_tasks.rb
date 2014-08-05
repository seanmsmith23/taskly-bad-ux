class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :task_list_id
      t.integer :user_id
      t.string :description
      t.date :due_date

      t.timestamps
    end
  end
end
