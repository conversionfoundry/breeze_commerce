# Set up products and such for the dummy store

FactoryGirl.define do

  factory :store_welcome_snippet, class: Breeze::Content::Snippet do
    content "<h1>Welcome to The Dummy Store</h1>"
  end

  factory :dummy_store, class: Breeze::Commerce::Store do
  end

  factory :dummies_list, class: Breeze::Commerce::ProductList do
    title "Dummies"
    list_type 'category'
  end

  factory :my_cart, class: Breeze::Commerce::Cart do
    title "My Cart"
  end

  factory :ventriloquist_dummy, class: Breeze::Commerce::Product do |vd|
    title "Ventriloquist Dummy"
    slug 'ventriloquist_dummy'
    permalink '/ventriloquist_dummy'
    available true
    # vd.variants { |v| [v.association(:freddie_dummy)] }
  end

  factory :freddie_dummy, class: Breeze::Commerce::Variant do |fd|
    name "Freddie"
    sku_code 'ventr-freddy'
    blurb 'Scary but compelling'
    cost_price_cents 5000
    sell_price_cents 10000
    available true
    fd.product { |p| p.association(:ventriloquist_dummy) }
  end

  # factory :baby_dummy

end