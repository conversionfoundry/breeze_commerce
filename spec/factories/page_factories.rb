FactoryGirl.define do

  factory :home_page, class: Breeze::Content::Page do
    title "Home"
    parent  nil
  end

  factory :terms_page, class: Breeze::Content::Page do
    title "Terms"
    parent  :home_page
    slug "terms"
  end

  factory :welcome_snippet, class: Breeze::Content::Snippet do
    content "<h1>Welcome to Breeze!</h1>"
  end   

end