class PasswordRecoveryService
  DEFAULT_TOKEN_EXPIRY = 24.hours

  class << self
    def new_token(user, expires_in = DEFAULT_TOKEN_EXPIRY)
      token = user.signed_id(expires_in: expires_in, purpose: :password_recovery)
      user.password_recovery_token = token
      user.save ? token : nil
    end

    def update_password_with_token(user, params)
      token = params[:token]
      password = params[:password]
      password_confirmation = params[:password_confirmation]

      return user unless find_user_by_token(token) == user

      user.password = password
      user.password_confirmation = password_confirmation

      if user.valid?
        user.password_recovery_token = nil
        user.save
      end

      user
    end

    def find_user_by_token(token)
      user = User.find_signed(token, purpose: :password_recovery)
      return nil if user.blank? || user.password_recovery_token_digest.blank?

      user.authenticate_password_recovery_token(token).presence
    end
  end
end
