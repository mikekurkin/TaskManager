class User < ApplicationRecord
  has_secure_password
  has_secure_password :password_recovery_token, validations: false

  has_many :my_tasks, class_name: 'Task',
                      inverse_of: :author,
                      foreign_key: :author_id,
                      dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task',
                            inverse_of: :assignee,
                            foreign_key: :assignee_id,
                            dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :email, format: { with: /\A\S+@.+\.\S+\z/ }
  validates :email, uniqueness: true
end
