class SendPasswordRecoveryRequestNotificationJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer

  def perform(user_id)
    user = User.find(user_id)
    return if user.blank?

    UserMailer.with(user: user).password_recovery_requested.deliver_now
  end
end
