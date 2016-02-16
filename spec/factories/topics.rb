FactoryGirl.define do
  factory :topic do
    name RandomData.random_name
    description RandomData.random_paragraph
  end
end
