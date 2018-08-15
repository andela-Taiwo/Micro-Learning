FactoryBot.define do
  factory :topic do
    title "A python beginner"
    description "The soft introduction to python"
  end
  factory :invalid_topic, parent: :topic do
    title ""
  end
end
