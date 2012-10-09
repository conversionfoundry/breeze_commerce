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

  # Manifest
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  # s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]
  
  
  # Dependencies
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  # s.add_dependency "jquery-rails"
  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency 'csv_shaper'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'will_paginate', "3.0.pre4"
  s.add_dependency "nested_form"
  s.add_dependency "haml"
  s.add_dependency "carrierwave"
  s.add_dependency "carrierwave-mongoid"
  # s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "mongoid-rspec"
  s.add_development_dependency "launchy"
  s.add_development_dependency "capybara"
  s.add_development_dependency 'factory_girl_rails'



  #s.add_development_dependency "sqlite3"
  
  # TODO: Declare dependency on Breeze Account
end
