module Breeze
  module Admin
    module Commerce
      class OrdersController < Breeze::Admin::Commerce::Controller
        respond_to :html, :js, :csv

        def index
          # binding.pry
          @orders = Breeze::Commerce::Order.unarchived.where(:store_id => store.id).to_a.sort_by{ |o| params[:sort] ? o.send(params[:sort]) : o.created_at }.paginate(:page => params[:page], :per_page => 15)
          @billing_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :billing).order(:sort_order)
          @shipping_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :shipping).order(:sort_order)
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
          if @order.update_attributes(params[:order])

            flash[:notice] = "The order was saved."
            # binding.pry
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
