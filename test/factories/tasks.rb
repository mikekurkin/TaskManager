FactoryBot.define do
  factory :task do
    name { 'MyString' }
    description { 'MyText' }
    author { nil }
    assignee { nil }
    state { 'MyString' }
    expired_at { '2022-10-11' }
  end
end
