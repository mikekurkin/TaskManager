class NewPasswordRecoveryForm
  include ActiveModel::Model

  attr_reader(:email)

  def email=(str)
    @email = str
    @user = nil
  end

  def user
    @user ||= User.find_by(email: email)
  end

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/ }
  validate :user_present?

  private

  def user_present?
    errors.add(:email, I18n.t('forms.new_password_recovery.no_user_found_error')) if user.blank?
  end
end
