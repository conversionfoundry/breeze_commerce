require 'faker'

FactoryGirl.define do

  factory :variant, class: Breeze::Commerce::Variant do
    product {FactoryGirl.create(:product)}
  	sequence(:name) { |n| "Variant #{n}"}
  	sequence(:sku_code) { |n| "VRN-#{n}"}
    cost_price_cents { Random.rand(1000) }
    sell_price_cents { cost_price_cents + Random.rand(1000) }
    published true
  end

  factory :unpublished_variant, class: Breeze::Commerce::Variant do
    product {FactoryGirl.create(:product)}
  	sequence(:name) { |n| "Variant #{n}"}
  	sequence(:sku_code) { |n| "VRN-#{n}"}
    cost_price_cents { Random.rand(1000) }
    sell_price_cents { cost_price_cents + Random.rand(1000) }
    published false
  end

  factory :discounted_variant, class: Breeze::Commerce::Variant do
    product {FactoryGirl.create(:product)}
    sequence(:name) { |n| "Variant #{n}"}
    sequence(:sku_code) { |n| "VRN-#{n}"}
    cost_price_cents { Random.rand(1000) }
    sell_price_cents { cost_price_cents + Random.rand(1000) + 100 }
    published true
    discounted true
    discounted_sell_price_cents { sell_price_cents - 100 }
  end

  factory :personalised_birthday_cake, class: Breeze::Commerce::Variant do
    product                   :birthday_cake
    name                      "Personalised Birthday Cake"
    sku_code                  "BDC-Peronalised"
    cost_price_cents          1000
    sell_price_cents          2000
    requires_customer_message true
    published                 true
  end

end