module Breeze
  module Commerce
    class Payment < Breeze::PayOnline::Payment

      field :archived, type: Boolean, default: false

      scope :archived, where(:archived => true)
      scope :unarchived, where(:archived.in => [ false, nil ])

      def order
        Breeze::Commerce::Order.find(reference)
      end
    end
  end
end
      