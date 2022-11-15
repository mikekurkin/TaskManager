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
    errors.add(:email, "no user found") if user.blank?
  end
end
