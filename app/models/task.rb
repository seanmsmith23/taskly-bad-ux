class Task < ActiveRecord::Base
  belongs_to :task_list

  validates :description, presence: true
  validate :past_due_date
  validate :task_assignments

  def past_due_date
    if (due_date - Date.today) < 0
      errors.add(:due_date, "Due date cannot be in the past!")
    end
  end

  def task_assignments
    all_users = [assigned_to, assigned_to_2, assigned_to_3, assigned_to_4]
    not_blank = all_users.delete_if{ |item| item == "" }
    users_to_assign = []
    not_blank.each {|item| users_to_assign << item }

    if assigned_to == "" && assigned_to_2 == "" && assigned_to_3 == "" && assigned_to_4 == ""
      errors.add(:assigned_to, "Must assign at least one user")
    else
      users_to_assign.each do |name|
        if users_to_assign.count(name) > 1
          errors.add(:assigned_to, "Can't assign more than one user to a task")
          break
        end
      end
    end
  end
end
