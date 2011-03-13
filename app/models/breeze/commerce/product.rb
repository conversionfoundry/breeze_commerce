module Breeze
  module Commerce
    class Product
      include Mongoid::Document
      include Mongoid::Timestamps

      include Breeze::Content::Mixins::Permalinks

      identity :type => String

      has_many_related :categories, :class_name => "Breeze::Commerce::Category", :stored_as => :array

      field :name
      field :code
      field :short_description
      field :full_description
      field :price, :type => Integer
      field :content, :markdown => true

      validates_presence_of :name, :code, :short_description
    end
  end
end
