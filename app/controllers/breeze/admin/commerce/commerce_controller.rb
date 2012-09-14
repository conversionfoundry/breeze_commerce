module Breeze
  module Admin
    module Commerce
      class CommerceController < Breeze::Admin::Commerce::Controller

        def setup_default
          @store = Store.new :title => "Store", :parent_id => Breeze::Content::NavigationItem.root.first.try(:id)
          @store.save!
          redirect_to admin_store_root_path
        end
        
      end
    end
  end
end
