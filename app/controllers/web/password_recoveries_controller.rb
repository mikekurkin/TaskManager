class Web::PasswordRecoveriesController < Web::ApplicationController
  def new
    return redirect_to(:board) if signed_in?

    @new_password_recovery = NewPasswordRecoveryForm.new
  end

  def create
    @new_password_recovery = NewPasswordRecoveryForm.new(new_password_recovery_params)

    return render(:new, status: :unprocessable_entity) if @new_password_recovery.invalid?

    email = UserMailer.with({ user: @new_password_recovery.user }).password_recovery_requested
    email.deliver_now
    redirect_to(:new_session,
                notice: I18n.t('controllers.web.password_recoveries.email_sent_notice'))
  end

  def show
    @password_recovery = PasswordRecoveryForm.new({ token: params[:token] })

    unless @password_recovery.token_valid?
      redirect_to(:new_password_recovery,
                  alert: @password_recovery.errors.where(:token).last.full_message)
    end
  end

  def update
    @password_recovery = PasswordRecoveryForm.new(password_recovery_params)

    unless @password_recovery.token_valid?
      return redirect_to(:new_password_recovery,
                         alert: @password_recovery.errors.where(:token).last.full_message)
    end

    return render(:show, status: :unprocessable_entity) if @password_recovery.invalid?

    PasswordRecoveryService.update_password_with_token(@password_recovery.user, password_recovery_params)

    redirect_to(:new_session,
                notice: I18n.t('controllers.web.password_recoveries.password_updated_notice'))
  end

  private

  def new_password_recovery_params
    params.require(:new_password_recovery_form).permit(:email)
  end

  def password_recovery_params
    params.require(:password_recovery_form).permit(:token, :password, :password_confirmation)
  end
end
