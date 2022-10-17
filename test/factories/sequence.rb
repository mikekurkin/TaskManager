FactoryBot.define do
  sequence(:first_name) { |n| "FirstName#{n}" }
  sequence(:last_name) { |n| "LastName#{n}" }
  sequence(:email) { |n| "email#{n}@example.com" }
  sequence(:password) { |n| "pa$sW0rd#{n}!" }
  sequence(:avatar) { |n| "https://randomuser.me/api/portraits/thumb/men/#{n % 100}.jpg" }
  sequence(:type) { [Developer, Manager].sample }

  sequence(:name) { |n| "Task ##{n}" }
  sequence(:description) { |n| "Task Description #{n}" }
  sequence(:expired_at) { (Date.current + rand(-30..30).days).strftime('%Y-%m-%d') }
end
