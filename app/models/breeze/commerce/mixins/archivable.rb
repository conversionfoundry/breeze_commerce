module Breeze
  module Commerce
    module Mixins
      module Archivable
        extend ActiveSupport::Concern

        included do

          field :archived, type: Boolean, default: false
          attr_accessible :archived
          
          scope :archived, where(:archived => true)
          scope :unarchived, where(:archived.in => [ false, nil ])
 
        end
    
      end
    end
  end
end
