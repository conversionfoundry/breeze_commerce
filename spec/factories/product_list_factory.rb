FactoryGirl.define do
  factory :product_list, class: Breeze::Commerce::ProductList do
    title 'title'
    list_type 'by_tags'
    use_pagination 'false'
    products_per_page '10'
  end
end
