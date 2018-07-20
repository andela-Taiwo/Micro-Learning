FactoryBot.define do
  factory :topic do
    title 'A python beginner'
    description 'The soft introduction to python'
  end
  factory :invalid_topic, parent: :topic do
    title ''
  end
end

# FactoryBot.define do
#
#   sequence :topic_title do |number|
#     "Title #{number} at #{DateTime.now.to_formatted_s(:short)}"
#   end
#   # user factory without associated stories
#   factory :topic do
#     title { generate(:topic_title) }
#     description 'The soft introduction to python'
#     factory :topics_with_resources do
#       transient do
#         resources_count 10
#       end
#
#       after(:create) do |topic, evaluator|
#         create_list(:resource, evaluator.resources_count, topics: [topic])
#       end
#     end
#   end
# end

# FactoryBot.define do
#   factory :topic do
#     sequence(:title) { |n| "Title #{n}" }
#     description 'The soft introduction to python'
#   end
#
#   factory :resource do
#     sequence(:title) { |n| "Title #{n}" }
#     description 'The soft introduction to python'
#     sequence(:url) { |n| "http://mdn#{n}.com/leason#{n}" }
#   end
#
#   factory :topic_with_resource, parent: :topic do
#     ignore do
#       resource { FactoryBot.create(:resource) }
#     end
#
#     after_create do |topic, evaluator|
#       topic.resources << evaluator.resource
#     end
#   end
# end
#
#
# FactoryBot.define do
#
#   # language factory with a `belongs_to` association for the profile
#   factory :resource do
#     sequence(:title) { |n| "Title #{n}" }
#     description 'The soft introduction to python'
#     sequence(:url) { |n| "http://mdn#{n}.com/leason#{n}" }
#     topic
#   end

#   # profile factory without associated languages
#   factory :topic do
#     sequence(:title) { |n| "Title #{n}" }
#     description 'The soft introduction to python'
#
#     # profile_with_languages will create language data after the profile has
#     # been created
#     factory :topic_with_resources do
#       # languages_count is declared as an ignored attribute and available in
#       # attributes on the factory, as well as the callback via the evaluator
#       transient do
#         resources_count 5
#       end
#
#       # the after(:create) yields two values; the profile instance itself and
#       # the evaluator, which stores all values from the factory, including
#       # ignored attributes; `create_list`'s second argument is the number of
#       # records to create and we make sure the profile is associated properly
#       # to the language
#       after(:create) do |topic, evaluator|
#         create_list(:resource, evaluator.resources_count, topics: [topic])
#       end
#     end
#   end
# end