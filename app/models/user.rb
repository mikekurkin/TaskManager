class User < ApplicationRecord
  has_secure_password

  has_many :my_tasks, class_name: 'Task',
                      inverse_of: :author,
                      dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task',
                            inverse_of: :assignee,
                            dependent: :nullify
end
