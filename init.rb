require 'breeze'
require 'breeze_account'
require 'breeze_pay_online'

Breeze.hook :define_abilities do |abilities_array, user, abilities|
  abilities.instance_eval do
    can :manage, Breeze::Commerce::Store if user.respond_to?(:roles) && user.roles.include?(:merchant)
    can :manage, Breeze::Commerce::Customer do |customer|
      customer.id == user.id
    end
    # can :manage, Breeze::Commerce::Customer if user.roles.include? :merchant
  end
end

Breeze.hook :admin_menu do |menu, user|
  if user.can? :manage, Breeze::Commerce::Store
    # Remove the menu item provided by Breeze Account, as we'll manage customers in the Store section
    menu.delete_if{|item| item[:name] == "Customers"}
  
    # Add Store menu item to main Breeze admin menu
    menu << { :name => "Store", :path => "/admin/store" } if user.can? :manage, Breeze::Content::Item
  else
    menu
  end
end

Breeze.hook :user_roles do |user_roles|
	user_roles << :merchant
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

