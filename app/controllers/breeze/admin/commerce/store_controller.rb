module Breeze
  module Admin
    module Commerce
      class StoreController < Breeze::Admin::Commerce::Controller

        # Set up a basic store
        # TODO: This is really duplicating the install generator. It should all be in seeds. Likewise for breeze_blog
        def setup_default
          store = Breeze::Commerce::Store.first || Breeze::Commerce::Store.create

          redirect_to admin_store_root_path
        end

        def index
          @published_products_count = Breeze::Commerce::Product.unarchived.published.count
          @top_customers = Breeze::Commerce::Customer.all.sort { |a,b| a.order_total <=> b.order_total }.reverse.paginate :page => 1, :per_page => 10
          @top_products = Breeze::Commerce::Product.unarchived.sort_by { |order| order.number_of_sales }.reverse.paginate :page => 1, :per_page => 10
          @fulfilled_orders = Breeze::Commerce::Order.unarchived.fulfilled
          @unfulfilled_orders = Breeze::Commerce::Order.unarchived.unfulfilled
        end
        
        def settings
          if request.put?
            if store.update_attributes params[:store]
              redirect_to admin_store_settings_path
            else
              render :action => "settings"
            end
          end
        end

        # TODO: Use update for this kind of method
        def set_default_shipping_method
          @shipping_method = Breeze::Commerce::ShippingMethod.find params[:shipping_method]
          store.default_shipping_method = @shipping_method
          store.save
          @shipping_methods = Breeze::Commerce::ShippingMethod.unarchived
        end

      end
    end
  end
end
