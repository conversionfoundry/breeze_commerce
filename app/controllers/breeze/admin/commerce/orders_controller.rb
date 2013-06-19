require 'csv_shaper'

module Breeze
  module Admin
    module Commerce
      class OrdersController < Breeze::Admin::Commerce::Controller
        respond_to :html, :js, :csv
        before_filter :get_order, except: [:index, :new]
        before_filter :get_order_statuses, only: [ :index, :new, :create, :edit ]

        helper_method :sort_method, :sort_direction

        def index

          @filters = Breeze::Commerce::Order::FILTERS
          if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
            @orders = Breeze::Commerce::Order.unarchived.actionable.includes(:line_items).send(params[:show])
          else
            @orders = Breeze::Commerce::Order.unarchived.actionable.includes(:line_items)
          end

          @orders = @orders.to_a.sort_by{ |o| o.send(sort_method) }
          if sort_direction == "desc"
            @orders = @orders.reverse
          end
          @orders = @orders.paginate(:page => params[:page], :per_page => 10)

          respond_to do |format|
            format.html
            format.js
            format.csv { @filename = "#{application_name} - Orders - #{Date.today.to_formatted_s(:db)}.csv" }
          end

        end

        def new
          @order = Breeze::Commerce::Order.new
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @order.billing_status = store.payment_confirmed_billing_status
          @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
        end

        def create
          if @order.save
            redirect_to edit_admin_store_order_path(@order)
          else
            @billing_statuses = Breeze::Commerce::OrderStatus.billing
            @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
            @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
            render :action => "new"
          end
        end

        def edit
          @order.shipping_address ||= Breeze::Commerce::Address.new
          @order.billing_address ||= Breeze::Commerce::Address.new
          @products = Breeze::Commerce::Product.unarchived.where(:store_id => store.id).order_by(:title.desc)
          @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
        end

        def update
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
            @billing_statuses = Breeze::Commerce::OrderStatus.billing
            @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
            @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
            render :action => "edit"
          end
        end

        def destroy
         @order.update_attributes(:archived => true)
         @order_count = Breeze::Commerce::Order.unarchived.count
        end

      protected

        def get_order
          @order = Breeze::Commerce::Order.find params[:id]
        end

        def get_order_statuses
          @billing_statuses = Breeze::Commerce::OrderStatus.billing.order_by(:sort_order.asc) # DRY up this repeated code
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping.order_by(:sort_order.asc)
        end

      private
        def sort_method
          %w[transaction_completed_at total email shipping_status billing_status].include?(params[:sort]) ? params[:sort] : "transaction_completed_at"
        end

        def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
        end

      end
    end
  end
end
