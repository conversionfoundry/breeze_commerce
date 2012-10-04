source 'https://rubygems.org'

gemspec # Dependencies are defined in the .gemspec file

gem "breeze", :github => 'isaacfreeman/breeze', :branch => 'master' # Local breeze is in ~/dev/breeze

group :test, :development do
  gem "breeze_account", :path => '~/dev/breeze_account'
  gem "breeze_pay_online", :path => '~/dev/breeze_pay_online'
  gem "breeze_apply_online", :path => '~/dev/breeze_apply_online'
  gem 'pry'
  gem 'pry-rails'
  gem 'magic_encoding'
end