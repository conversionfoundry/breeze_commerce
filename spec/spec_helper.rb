require 'rubygems'
require 'spork'

Spork.prefork do 

  ENV["RAILS_ENV"] ||= 'test'

  require File.expand_path("../dummy/config/environment", __FILE__)
  # require Rails.root.join('db','seeds')

  require 'rspec/rails'
  require 'capybara/rspec'
  require 'factory_girl'
  require "database_cleaner"
  require 'shoulda'
  require 'haml'
  require 'pry'
  # require 'rspec/autorun'

  ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    config.before :each do
      Mongoid.purge!
      load "#{ENGINE_RAILS_ROOT}/db/seeds.rb" 
    end

    # Include Factory Girl syntax to simplify calls to factories
    config.include FactoryGirl::Syntax::Methods

    config.include Breeze::Commerce::Engine.routes.url_helpers

    config.include Devise::TestHelpers, :type => :controller

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

  FactoryGirl.find_definitions
end

Spork.each_run do

end
