require 'faker'

FactoryGirl.define do
  # factory :order_with_address do
  #   title     'Example Order'
  #   address  { FactoryGirl.build(:address) }
  # end

  factory :address, class: Breeze::Commerce::Address do
    name { [Faker::Name.first_name, Faker::Name.last_name].join(' ') }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    postcode { Faker::Address.postcode }
    country { Faker::Address.country }
    phone { Faker::PhoneNumber.phone_number }

  end
end