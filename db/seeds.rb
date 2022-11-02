admin = Admin.find_or_create_by(first_name: 'admin', last_name: 'admin', email: 'admin@example.com')
admin.password = 'admin'
admin.save

if ENV['DEMO']
  manager = Manager.find_or_create_by(first_name: 'manager', last_name: 'manager', email: 'manager@example.com')
  manager.password = 'manager'
  manager.save

  developer = Developer.find_or_create_by(first_name: 'developer', last_name: 'developer', email: 'developer@example.com')
  developer.password = 'developer'
  developer.save

  60.times do |i|
    u = [Manager, Developer].sample.new
    u.first_name = "FirstName#{i}"
    u.last_name = "LastName#{i}"
    u.email = "email#{i}@example.com"
    u.password = "pa$sW0rd#{i}!"
    u.avatar = "https://randomuser.me/api/portraits/thumb/men/#{i % 100}.jpg"
    u.save
  end

  100.times do |i|
    t = Task.new
    t.name = "Task#{i}"
    t.description = "Description#{i}"
    t.author = Manager.all.sample
    t.save
  end

  77.times do
    t = Task.all.sample
    t.send_to_development
    t.assignee = Developer.all.sample
    t.save
  end

  40.times { Task.with_state(:in_development).sample.send_to_qa }
  24.times { Task.with_state(:in_qa).sample.send_to_code_review }
  12.times { Task.with_state(:in_code_review).sample.make_ready_for_release }
  11.times { Task.with_state(:ready_for_release).sample.release }

  4.times { Task.with_state(:released).sample.archive }
end
