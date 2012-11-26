source 'https://rubygems.org'

gemspec # Dependencies are defined in the .gemspec file

gem "breeze", :github => 'isaacfreeman/breeze', branch: '1.0.x'
gem "breeze_account", :github => 'isaacfreeman/breeze_account', branch: 'master'
gem "breeze_pay_online", :github => 'isaacfreeman/breeze_pay_online', branch: 'master'
gem "breeze_apply_online", :github => 'isaacfreeman/breeze_apply_online', branch: 'master'

group :development do 
  gem 'fuubar'
end

group :test, :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'magic_encoding'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'capybara'
end

group :test do
	gem 'faker'
	gem 'database_cleaner'
	gem 'launchy'
end