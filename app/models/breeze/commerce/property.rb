module Breeze
  module Commerce
    class Property
      include Mongoid::Document

      attr_accessible :product_ids, :name

      has_and_belongs_to_many :product, :class_name => "Breeze::Commerce::Product"
      has_many :options, :class_name => "Breeze::Commerce::Option"
      
      field :name      

      validates_presence_of :name

      def options=(values)
        write_attribute :options, (Array(values).map { |option|
          option.split(/[ \n\t]*,[ \n\t]*/).map { |o| o.strip }
        }.flatten.reject(&:blank?).sort.uniq)
      end

    end
  end
end
