# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def task_created
    task = Task.first
    user = task.author
    params = { user: user, task: task }

    UserMailer.with(params).task_created
  end

  def task_updated
    task = Task.first
    user = task.author
    params = { user: user, task: task }

    UserMailer.with(params).task_updated
  end

  def task_destroyed
    task = Task.first
    user = task.author
    params = { user: user, task: task }

    UserMailer.with(params).task_destroyed
  end

  def password_recovery_requested
    user = User.first
    params = { user: user, token: user.signed_id(purpose: :dummy, expires_in: 0) }

    UserMailer.with(params).password_recovery_requested
  end
end
