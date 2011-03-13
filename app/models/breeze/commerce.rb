module Breeze
  module Commerce
    PRODUCT_PART = /product\/([^\/\.]+)/.freeze unless defined?(PRODUCT_PART)
    PERMALINK = /(\/(#{PRODUCT_PART}))?(\.\w+)?$/.freeze unless defined?(PERMALINK)
  end
end

