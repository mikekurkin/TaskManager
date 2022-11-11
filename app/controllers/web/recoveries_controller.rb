class Web::RecoveriesController < Web::ApplicationController
  def new
    redirect_to(:board) and return if signed_in?

    @new_recovery = NewRecoveryForm.new
  end

  def create
    @new_recovery = NewRecoveryForm.new(new_recovery_params)

    if @new_recovery.valid?
      email = UserMailer.with({ user: @new_recovery.user }).recovery_requested
      email.deliver_now
      redirect_to(:new_session, notice: 'Email sent')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def show
    @recovery = RecoveryForm.new
    @token = params[:token]
    @user = User.get_by_recovery_token(@token)

    redirect_to(:new_recovery, alert: 'Token is invalid') unless @user.present?
  end

  def update
    @recovery = RecoveryForm.new(recovery_params)
    @token = recovery_params[:token]
    @user = User.get_by_recovery_token(@token)

    redirect_to(:new_recovery, alert: 'Token is invalid') and return unless @user.present?

    if @recovery.valid?
      @user.update_password_with_recovery_token(recovery_params)
      redirect_to(:new_session, notice: 'Password updated')
    else
      render(:show, status: :unprocessable_entity)
    end
  end

  private

  def new_recovery_params
    params.require(:new_recovery_form).permit(:email)
  end

  def recovery_params
    params.require(:recovery_form).permit(:token, :password, :password_confirmation)
  end
end
