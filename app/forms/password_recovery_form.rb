class PasswordRecoveryForm
  include ActiveModel::Model

  attr_accessor(
    :password,
    :password_confirmation,
  )

  attr_reader(:token)

  def token=(str)
    @token = str
    @user = nil
  end

  def user
    @user ||= PasswordRecoveryService.find_user_by_token(@token)
  end

  def token_valid?
    user_present?
    errors.where(:token).blank?
  end

  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  validate :user_present?

  private

  def user_present?
    errors.add(:token, :invalid) if user.blank?
  end
end
