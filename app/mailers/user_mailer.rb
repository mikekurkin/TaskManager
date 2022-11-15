class UserMailer < ApplicationMailer
  def task_created
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email, subject: I18n.t('mailers.user.task_created_subject'))
  end

  def task_updated
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email, subject: I18n.t('mailers.user.task_updated_subject'))
  end

  def task_destroyed
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email, subject: I18n.t('mailers.user.task_destroyed_subject'))
  end

  def password_recovery_requested
    @user = params[:user]
    @token = params[:token] || @user.new_password_recovery_token

    mail(to: @user.email, subject: I18n.t('mailers.user.password_recovery_requested_subject'))
  end
end
