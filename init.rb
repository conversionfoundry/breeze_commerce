Breeze.configure do
  Breeze::Content.register_class Breeze::Commerce::Commerce
end

Breeze.hook :define_abilities do |user, abilities|
 # abilities.instance_eval do
 #   can :manage, Breeze::Commerce::Shop if user.editor?
 # end
end

Breeze.hook :admin_menu do |menu, user|
  menu << { :name => "Store", :path => "/admin/store" } if user.can? :manage, Breeze::Content::Item
end

Breeze.hook :get_content_by_permalink do |permalink_or_content|
  Rails.logger.debug "permalink_or_content(commerce): #{permalink_or_content}"
  case permalink_or_content
  when Breeze::Content::Item then permalink_or_content
  when String then Breeze::Commerce::Commerce.find_by_permalink permalink_or_content
  else nil
  end
end

Rails.application.config.to_prepare do
  Breeze::Controller.helper Breeze::Commerce::ContentsHelper
end
