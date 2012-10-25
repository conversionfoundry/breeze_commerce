require 'csv_shaper'

module Breeze
  module Admin
    module Commerce
      class OrdersController < Breeze::Admin::Commerce::Controller
        respond_to :html, :js, :csv

        # Index action takes a parameter :sort for sorting
        # TODO: Filtering by status?
        def index
          # Find all unarchived orders for the store which are ready for showing in admin (i.e. have gone to checkout)
          @orders = Breeze::Commerce::Order.unarchived.where(:store_id => store.id).find_all{ |o| o.show_in_admin? }
          # # @filters = Breeze::Commerce::Order::FILTERS
          # # if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
          # #   @orders = @orders.send(params[:show])
          # # end  
          @orders = @orders.to_a.sort_by{ |o| params[:sort] ? o.send(params[:sort]) : - o.created_at.to_i }.paginate(:page => params[:page], :per_page => 15)

          @billing_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :billing).order_by(:sort_order.asc) # DRY up this repeated code
          @shipping_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :shipping).order_by(:sort_order.asc)
        end
        
        def show
          @order = store.orders.find(params[:id])
        end
        
        def new
          @order = store.orders.new
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :billing)
          @shipping_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :shipping)
        end
        
        def create
          @order = store.orders.build params[:order]
          if @order.save
            redirect_to admin_store_orders_path
          else
            render :action => "new"
          end
        end

        def edit
          @order = store.orders.find params[:id]
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :billing)
          @shipping_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :shipping)
          @products = Breeze::Commerce::Product.unarchived.where(:store_id => store.id).order_by(:title.desc)
        end

        def update
          @order = store.orders.find params[:id]
          old_shipping_status = @order.shipping_status

          if @order.update_attributes(params[:order])
            flash[:notice] = "The order was saved."

            unless @order.shipping_status == old_shipping_status
              Breeze::Admin::Commerce::OrderMailer.shipping_status_change_customer_notification(@order).deliver 
            end

            respond_to do |format|
              format.html { redirect_to edit_admin_store_order_path(@order) }
              format.js
            end
          else
            render :action => "edit"
          end
        end
        
        def destroy
         @order = store.orders.find(params[:id])
         @order.update_attributes(:archived => true)
        end
        
      end
    end
  end
end
