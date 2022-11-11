class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_token, validations: false

  DEFAULT_TOKEN_EXPIRY = 24.hours

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

  def new_recovery_token(expires_in = DEFAULT_TOKEN_EXPIRY)
    token = signed_id(expires_in: expires_in, purpose: :recovery)
    self.recovery_token = token
    save ? token : nil
  end

  def update_password_with_recovery_token(params)
    token = params[:token]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    return self unless self.class.get_by_recovery_token(token) == self

    self.password = password
    self.password_confirmation = password_confirmation

    if valid?
      self.recovery_token = nil
      save
    end
    self
  end

  def self.get_by_recovery_token(token)
    user = find_signed(token, purpose: :recovery)
    return nil if user.nil? || user.recovery_token_digest.nil?

    user.authenticate_recovery_token(token).presence
  end
end
