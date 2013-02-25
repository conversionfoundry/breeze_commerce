module Breeze
  module Commerce
    module AddressesHelper

      def html_address(address, include_name=true)
        result = '<p class="address">'
        if include_name
          result += '<span class="name">' + (address.name || 'Unknown Name') + '</span><br />'
        end
        result += '<span class="address">' + (address.address || '') + '</span><br />'
        result += '<span class="city">' + (address.city || '') + '</span><br />' unless address.city.blank?
        result += '<span class="state">' + (address.state || '') + '</span><br />' unless address.state.blank?
        result += '<span class="postcode">' + (address.postcode || '') + '</span><br />' unless address.postcode.blank?
        result += '<span class="country">' + (address.country || '') + '</span><br />'
        (result += '<span class="phone">' + 'Contact Phone:' + address.phone + '</span>') unless address.phone.blank?
        result += '</p>'
        result.html_safe
      end

    end
  end
end

