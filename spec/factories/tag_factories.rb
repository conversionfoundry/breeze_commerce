require 'faker'

FactoryGirl.define do
  factory :tag, class: Breeze::Commerce::Tag do
    sequence(:name) { |n| "tag#{n}"}
    sequence(:slug) { |n| "slug#{n}"}

    factory :invalid_tag do
    	name nil
    end
  end
end