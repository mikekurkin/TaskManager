class User < ApplicationRecord
  has_secure_password

  has_many :my_tasks, class_name: 'Task',
                      inverse_of: :author,
                      dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task',
                            inverse_of: :assignee,
                            dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :email, format: { with: /.*@.*/ }
  validates :email, uniqueness: true
end
