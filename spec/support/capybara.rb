require "capybara/rails"
require 'capybara/rspec'
require 'capybara-webkit'

# Setup capybara webkit as the driver for javascript-enabled tests.
Capybara.javascript_driver = :webkit
# Capybara.current_driver = :selenium

# In our setup, for some reason the browsers capybara was driving were
# not openning the right host:port. Below, we force the correct
# host:port.
Capybara.server_port = 3001
Capybara.app_host = 'http://0.0.0.0:3001'

