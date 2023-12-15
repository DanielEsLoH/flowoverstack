# app/spec/factories/question.rb
FactoryBot.define do
  factory :question do
    title { "Valid Title" }
    description { "Valid Description" }
    association :user, factory: :user
  end
end
