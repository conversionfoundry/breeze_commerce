require 'faker'

FactoryGirl.define do
  factory :category, class: Breeze::Commerce::Category do
    sequence(:name) { |n| "category#{n}"}
    sequence(:slug) { |n| "slug#{n}"}

    factory :invalid_category do
    	name nil
    end
  end
end