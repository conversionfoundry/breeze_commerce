FactoryGirl.define do

  factory :home_page, class: Breeze::Content::Page do
    title "Home"
    parent  nil
    # placements { [ double ] }
  end

  factory :welcome_snippet, class: Breeze::Content::Snippet do
    content "<h1>Welcome to Breeze!</h1>"
  end

  factory :emergency_user, class: Breeze::Admin::User do
		first_name "Emergency"
		last_name "User"
		email "emergency@example.com"
		password "logmein"
		password_confirmation "logmein"
		roles [ :admin ]
	end
       

end