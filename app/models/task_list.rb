class TaskList < ActiveRecord::Base
  has_many :tasks

  validates :name, presence: true

  def self.created_by(user)
    TaskList.includes(:tasks).where(:tasks => {:user_id => user})
  end

  def self.assigned_to(user)
    TaskList.includes(:tasks).where(:tasks => {:assigned_to => user})
  end
end