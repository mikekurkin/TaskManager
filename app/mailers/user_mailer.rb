class UserMailer < ApplicationMailer
  def task_created
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email, subject: 'New Task Created')
  end

  def task_updated
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email, subject: 'Task Changed')
  end

  def task_destroyed
    @user = params[:user]
    @task = params[:task]

    mail(to: @user.email, subject: 'Task Deleted')
  end

  def recovery_requested
    @user = params[:user]
    @token = params[:token] || @user.new_recovery_token

    mail(to: @user.email, subject: 'Password Recovery')
  end
end
