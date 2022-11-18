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
    errors.add(:email, :no_user_found) if user.blank?
  end
end
