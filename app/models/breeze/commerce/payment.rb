module Breeze
  module Commerce
    class Payment < Breeze::PayOnline::Payment
      include Mixins::Archivable

      attr_accessible :name, :email, :amount, :reference, :currency

      field :created_by_merchant, type: Boolean, default: false

      def order
        Breeze::Commerce::Order.find(reference)
      end
    end
  end
end
      