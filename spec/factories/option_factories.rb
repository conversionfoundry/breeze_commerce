require 'faker'

FactoryGirl.define do
  factory :option, class: Breeze::Commerce::Option do
    property {FactoryGirl.create(:property)}
  	sequence(:name) { |n| "Option #{n}"}
  end
end