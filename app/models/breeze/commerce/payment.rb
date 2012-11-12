module Breeze
  module Commerce
    class Payment < Breeze::PayOnline::Payment
      include Mixins::Archivable

      attr_accessible :name, :email, :amount, :reference, :currency, :created_by_merchant, :order

      belongs_to :order, foreign_key: :reference
      field :created_by_merchant, type: Boolean, default: false

      validates_presence_of :currency

    end
  end
end
      