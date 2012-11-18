namespace :breeze do
  namespace :commerce do
    desc "install store and standard order statuses"
    task :seed => :environment do
      ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
      load "#{ENGINE_RAILS_ROOT}../db/seeds.rb" 
    end
  end
end