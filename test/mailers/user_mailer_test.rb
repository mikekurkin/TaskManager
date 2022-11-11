require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'task created' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_created

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.local'], email.from
    assert_equal [user.email], email.to
    assert_equal 'New Task Created', email.subject
    assert email.body.to_s.include?("Task ##{task.id} was created")
  end

  test 'task updated' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_updated

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.local'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Task Changed', email.subject
    assert email.body.to_s.include?("Task ##{task.id} was changed")
  end

  test 'task destroyed' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_destroyed

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.local'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Task Deleted', email.subject
    assert email.body.to_s.include?("Task ##{task.id} was deleted")
  end

  test 'recovery requested' do
    user = create(:user)
    params = { user: user }
    email = UserMailer.with(params).recovery_requested

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@taskmanager.local'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Password Recovery', email.subject
    assert email.body.to_s.include?('Click on the link below to recover your password.')
    assert email.body.to_s.include?('recovery?token=')
  end
end
