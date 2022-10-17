admin = Admin.find_or_create_by(first_name: 'admin', last_name: 'admin', email: 'admin@example.com')
admin.password = 'admin'
admin.save

60.times do |i|
  u = [Manager, Developer].sample.new
  u.first_name = "FirstName#{i}"
  u.last_name = "LastName#{i}"
  u.email = "email#{i}@example.com"
  u.password = "pa$sW0rd#{i}!"
  u.avatar = "https://randomuser.me/api/portraits/thumb/men/#{i % 100}.jpg"
  u.save
end
