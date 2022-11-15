class PasswordRecoveryForm
  include ActiveModel::Model

  attr_accessor(
    :password,
    :password_confirmation,
    :token,
  )

  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
end
