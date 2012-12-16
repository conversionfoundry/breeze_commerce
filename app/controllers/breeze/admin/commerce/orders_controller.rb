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
          @orders = Breeze::Commerce::Order.unarchived.show_in_admin.includes(:line_items)
          # # @filters = Breeze::Commerce::Order::FILTERS
          # # if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
          # #   @orders = @orders.send(params[:show])
          # # end  
          @orders = @orders.to_a.sort_by{ |o| params[:sort] ? o.send(params[:sort]) : - o.created_at.to_i }.paginate(:page => params[:page], :per_page => 10)

          @billing_statuses = Breeze::Commerce::OrderStatus.billing.order_by(:sort_order.asc) # DRY up this repeated code
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping.order_by(:sort_order.asc)
        end
        
        def new
          @order = Breeze::Commerce::Order.new
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::OrderStatus.billing
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
        end
        
        def create
          @order = Breeze::Commerce::Order.build params[:order]
          if @order.save
            redirect_to admin_store_orders_path
          else
            @billing_statuses = Breeze::Commerce::OrderStatus.billing
            @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
            render :action => "new"
          end
        end

        def edit
          @order = Breeze::Commerce::Order.find params[:id]
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::OrderStatus.billing
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
          @products = Breeze::Commerce::Product.unarchived.where(:store_id => store.id).order_by(:title.desc)
        end

        def update
          @order = Breeze::Commerce::Order.find params[:id]
          old_shipping_status = @order.shipping_status

          if @order.update_attributes(params[:order])
            flash[:notice] = "The order was saved."

            unless @order.shipping_status == old_shipping_status
              Breeze::Commerce::OrderMailer.shipping_status_change_customer_notification(@order).deliver 
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
         @order = Breeze::Commerce::Order.find(params[:id])
         @order.update_attributes(:archived => true)
         @order_count = Breeze::Commerce::Order.unarchived.count
        end
        
      end
    end
  end
end
