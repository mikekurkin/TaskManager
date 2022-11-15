class Web::RecoveriesController < Web::ApplicationController
  def new
    return redirect_to(:board) if signed_in?

    @new_recovery = NewRecoveryForm.new
  end

  def create
    @new_recovery = NewRecoveryForm.new(new_recovery_params)

    return render(:new, status: :unprocessable_entity) if @new_recovery.invalid?

    email = UserMailer.with({ user: @new_recovery.user }).recovery_requested
    email.deliver_now
    redirect_to(:new_session, notice: 'Email sent')
  end

  def show
    @recovery = RecoveryForm.new
    @token = params[:token]
    @user = User.get_by_recovery_token(@token)

    redirect_to(:new_recovery, alert: 'Token is invalid') if @user.blank?
  end

  def update
    @recovery = RecoveryForm.new(recovery_params)
    @token = recovery_params[:token]
    @user = User.get_by_recovery_token(@token)

    return redirect_to(:new_recovery, alert: 'Token is invalid') if @user.blank?

    return render(:show, status: :unprocessable_entity) if @recovery.invalid?

    @user.update_password_with_recovery_token(recovery_params)
    redirect_to(:new_session, notice: 'Password updated')
  end

  private

  def new_recovery_params
    params.require(:new_recovery_form).permit(:email)
  end

  def recovery_params
    params.require(:recovery_form).permit(:token, :password, :password_confirmation)
  end
end
