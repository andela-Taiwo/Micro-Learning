FactoryBot.define do
  factory :user do
    username "testuser007"
    email "test007@example.com"
    password "test1234"
    password_confirmation "test1234"
  end
  factory :admin, parent: :user do
    email "testadmin@example.com"
    admin  true
    username "crazylove"
  end
end
