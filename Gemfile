source 'https://rubygems.org' 
ruby "1.9.3"

gem "breeze", :github => "leftclick/breeze", :branch => '1.0.x' 
gem "breeze_account", :github => "leftclick/breeze_account", :branch => 'master' 
gem "breeze_pay_online", :github => "leftclick/breeze_pay_online", :branch => 'master' 
gem "breeze_apply_online", :github => "leftclick/breeze_apply_online", :branch => 'master' 

gemspec # Dependencies are defined in the .gemspec file

group :test, :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'magic_encoding'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'fuubar'
end

group :test do
  gem 'spork'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'rb-fsevent'
  gem 'shoulda'
  gem 'jasmine'
	gem 'faker'
	gem 'database_cleaner'
	gem 'launchy'
  gem 'capybara-webkit'
end