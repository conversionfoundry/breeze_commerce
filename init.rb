require 'breeze'

## TODO: Not sure why this isn't working
# Breeze.hook :define_abilities do |user, abilities|
#   # Rails.logger.debug '********** user: ' + user.inspect
#   # Rails.logger.debug '********** abilities: ' + abilities.inspect
#   
#   abilities.instance_eval do
#     can :manage, Breeze::Commerce::Shop if user.editor?
#   end
# end

Breeze.hook :admin_menu do |menu, user|
  # Remove the menu item provided by Breeze Account, as we'll manage customers in the Store section
  menu.delete_if{|item| item[:name] == "Customers"}
  
  menu << { :name => "Store", :path => "/admin/store" } if user.can? :manage, Breeze::Content::Item
end

Breeze.hook :get_content_by_permalink do |permalink_or_content|
  case permalink_or_content
  when Breeze::Content::Item then permalink_or_content
  # when String then Breeze::Commerce::Store.find_by_permalink permalink_or_content
  else nil
  end
end

Breeze.hook :component_info do |component_info|
	component_info << {:name => 'Breeze Commerce', :version => Breeze::Commerce::VERSION }
end

# Rails.application.config.to_prepare do
#   Breeze::Controller.helper Breeze::Commerce::ContentsHelper
# end



