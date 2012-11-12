FactoryGirl.define do

  factory :payment, class: Breeze::Commerce::Payment do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    order { FactoryGirl.create(:order) }
    amount { Random.rand(1000) }
    currency 'NZD'
    created_by_merchant false
  end       

end