FactoryBot.define do
  factory :resource do
    title 'A python beginner'
    description 'The soft introduction to python'
    url 'https://mdn.com/python'
  end
  factory :invalid_resource, parent: :resource do
    title ''
  end
end