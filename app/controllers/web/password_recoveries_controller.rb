class Web::PasswordRecoveriesController < Web::ApplicationController
  def new
    return redirect_to(:board) if signed_in?

    @new_password_recovery = NewPasswordRecoveryForm.new
  end

  def create
    @new_password_recovery = NewPasswordRecoveryForm.new(new_password_recovery_params)

    return render(:new, status: :unprocessable_entity) if @new_password_recovery.invalid?

    UserMailer.with({ user: @new_password_recovery.user }).password_recovery_requested.deliver_now

    redirect_to(:new_session,
                notice: I18n.t(:email_sent, scope: 'password_recoveries.notices'))
  end

  def show
    @password_recovery = PasswordRecoveryForm.new({ token: params[:token] })

    if @password_recovery.invalid?
      token_error = @password_recovery.errors.where(:token).last

      return redirect_to(:new_password_recovery, alert: token_error.full_message) if token_error.present?
    end
  end

  def update
    @password_recovery = PasswordRecoveryForm.new(password_recovery_params)

    if @password_recovery.invalid?
      token_error = password_recovery.errors.where(:token).last

      return redirect_to(:new_password_recovery, alert: token_error.full_message) if token_error.present?

      return render(:show, status: :unprocessable_entity)
    end

    PasswordRecoveryService.update_password_with_token(@password_recovery.user, password_recovery_params)

    redirect_to(:new_session,
                notice: I18n.t(:password_updated, scope: 'password_recoveries.notices'))
  end

  private

  def new_password_recovery_params
    params.require(:new_password_recovery_form).permit(:email)
  end

  def password_recovery_params
    params.require(:password_recovery_form).permit(:token, :password, :password_confirmation)
  end
end
