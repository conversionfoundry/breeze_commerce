module Breeze
  module Commerce
    class Order
      # TODO: belongs_to :user
      embeds_many :line_items 
    end
  end
end
