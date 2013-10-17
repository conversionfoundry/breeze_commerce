$:.push File.expand_path("../lib", __FILE__)

require "breeze/commerce/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "breeze_commerce"
  s.version     = Breeze::Commerce::VERSION
  s.authors     = ["Logan Newport, Blair Neate, Isaac Freeman"]
  s.email       = ["isaac@leftclick.com"]
  s.homepage    = ""
  s.summary     = "Online Store for the Breeze CMS"
  s.description = "Breeze Commerce adds product management and a checkout funnel to Breeze."

  s.files         = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.0'
  s.required_rubygems_version = '>= 1.3.6'

  # Dependencies
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  # s.add_dependency "jquery-rails"
  s.add_dependency "breeze", ">= 1.0.0"
  s.add_dependency "breeze_account", ">= 1.0.0"
  s.add_dependency "breeze_pay_online", ">= 0.1.0"
  s.add_dependency "breeze_apply_online", ">= 0.1.0"
  s.add_dependency "carrierwave"
  s.add_dependency "carrierwave-mongoid", "~> 0.1.0"
  s.add_dependency "haml"
  s.add_dependency "kaminari"
  s.add_dependency "nested_form"
  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "sass-rails"
  s.add_dependency 'csv_shaper'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-fileupload-rails'
  s.add_dependency 'will_paginate', "3.0.pre4"
  s.add_dependency "twitter-bootstrap-rails"
  s.add_dependency "whenever"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "mongoid-rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails'
end
