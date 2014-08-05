class User < ActiveRecord::Base
  has_secure_password

  belongs_to :user
  belongs_to :assignee, {}

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
