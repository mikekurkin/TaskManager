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
    redirect_to(:new_session, notice: 'Email sent')
  end

  def show
    @password_recovery = PasswordRecoveryForm.new
    @token = params[:token]
    @user = User.get_by_password_recovery_token(@token)

    redirect_to(:new_password_recovery, alert: 'Token is invalid') if @user.blank?
  end

  def update
    @password_recovery = PasswordRecoveryForm.new(password_recovery_params)
    @token = password_recovery_params[:token]
    @user = User.get_by_password_recovery_token(@token)

    return redirect_to(:new_password_recovery, alert: 'Token is invalid') if @user.blank?

    return render(:show, status: :unprocessable_entity) if @password_recovery.invalid?

    @user.update_password_with_recovery_token(password_recovery_params)
    redirect_to(:new_session, notice: 'Password updated')
  end

  private

  def new_password_recovery_params
    params.require(:new_password_recovery_form).permit(:email)
  end

  def password_recovery_params
    params.require(:password_recovery_form).permit(:token, :password, :password_confirmation)
  end
end
