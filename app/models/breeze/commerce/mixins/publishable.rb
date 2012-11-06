module Breeze
  module Commerce
    module Mixins
      module Publishable
        extend ActiveSupport::Concern

        included do

          field :published, :type => Boolean, default: false
          attr_accessible :published
          
          scope :published, where(:published => true)
          scope :unpublished, where(:published.in => [ false, nil ])
 
        end
    
      end
    end
  end
end
