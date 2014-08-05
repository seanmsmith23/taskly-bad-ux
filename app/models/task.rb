class Task < ActiveRecord::Base
  belongs_to :task_list

  validates :description, presence: true
  validate :past_due_date

  def past_due_date
    if (due_date - Date.today) < 0
      errors.add(:due_date, "Due date cannot be in the past!")
    end
  end
end
