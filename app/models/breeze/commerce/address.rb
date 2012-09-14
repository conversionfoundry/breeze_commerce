module Breeze
  module Commerce
    class Address
      include Mongoid::Document

      embedded_in :order, :class_name => "Breeze::Commerce::Order", :inverse_of => :shipping_address
      embedded_in :order, :class_name => "Breeze::Commerce::Order", :inverse_of => :billing_address
      embedded_in :order, :class_name => "Breeze::Commerce::Customer", :inverse_of => :shipping_address
      embedded_in :order, :class_name => "Breeze::Commerce::Customer", :inverse_of => :billing_address

      field :name
      field :address # May be multi-line
      field :city
      field :state
      field :postcode
      field :country
      field :phone

      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])
      
      def to_html
        result = '<p class="address">'
        result += '<span class="name">' + (name || 'Unknown Name') + '</span><br />'
        result += '<span class="name">' + (address || '') + '</span><br />'
        result += '<span class="name">' + (city || '') + '</span><br />'
        result += '<span class="name">' + (state || '') + '</span><br />'
        result += '<span class="name">' + (postcode || '') + '</span><br />'
        result += '<span class="name">' + (country || '') + '</span><br />'
        (result += '<span class="name">' + 'Contact Phone:' + phone + '</span>') if phone
        result += '</p>'
        result.html_safe
      end

      def to_s
        result = ''
        result += (name || 'Unknown Name') + "\n"
        result += (address || '') + "\n"
        result += (city || '') + "\n"
        result += (state || '') + "\n"
        result += (postcode || '') + "\n"
        result += (country || '') + "\n"
        (result += 'Contact Phone:' + phone) if phone
      end
    end
  end
end
