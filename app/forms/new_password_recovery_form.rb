class NewPasswordRecoveryForm
  include ActiveModel::Model

  attr_accessor(
    :email,
  )

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/ }
  validate :user_present?

  def user
    User.find_by(email: email)
  end

  private

  def user_present?
    errors.add(:email, I18n.t('forms.new_password_recovery.no_user_found_error')) if user.blank?
  end
end
