class Task < ActiveRecord::Base
  belongs_to :task_list

  validates :description, presence: true
  validate :past_due_date
  validate :task_is_assigned

  def past_due_date
    if (due_date - Date.today) < 0
      errors.add(:due_date, "Due date cannot be in the past!")
    end
  end

  def task_is_assigned
    all_users = [assigned_to, assigned_to_2, assigned_to_3, assigned_to_4]
    not_blank = all_users.delete_if{ |item| item == "" }
    fail = []

    p'*'*80
    p all_users
    p'*'*80
    p not_blank
    p'*'*80

    if assigned_to == "" && assigned_to_2 == "" && assigned_to_3 == "" && assigned_to_4 == ""
      errors.add(:assigned_to, "Must assign at least one user")
    elsif
      all_users.each {|item| fail << item }
    end
    p fail
  end
end
