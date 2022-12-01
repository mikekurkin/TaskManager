class UserMailer < ApplicationMailer
  def task_created
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email)
  end

  def task_updated
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email)
  end

  def task_destroyed
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email)
  end

  def password_recovery_requested
    @user = params[:user]
    @token = params[:token] || PasswordRecoveryService.new_token(@user)

    mail(to: @user.email)
  end
end
