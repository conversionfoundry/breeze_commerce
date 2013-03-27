module Breeze
  module Admin
    module Commerce
      class CustomersController < Breeze::Admin::Commerce::Controller
        helper_method :sort_method, :sort_direction

        def index
          @filters = Breeze::Commerce::Customer::FILTERS
          if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
            @customers = Breeze::Commerce::Customer.unarchived.includes(:orders).send(params[:show])
          else
            @customers = Breeze::Commerce::Customer.unarchived.includes(:orders)
          end  

          @customers = @customers.order_by(sort_method + " " + sort_direction).paginate(:page => params[:page], :per_page => 15)
        end

        def new
          @customer = Breeze::Commerce::Customer.new
          @customer.shipping_address ||= Breeze::Commerce::Address.new
          @customer.billing_address ||= Breeze::Commerce::Address.new
        end
        
        def create
          @customer = Breeze::Commerce::Customer.new params[:customer]
          if @customer.save
            redirect_to admin_store_customers_path
          else
            render :action => "new"
          end
        end

        def edit
          @customer = Breeze::Commerce::Customer.find params[:id]
          @customer.shipping_address ||= Breeze::Commerce::Address.new
          @customer.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::OrderStatus.billing
          @shipping_statuses = Breeze::Commerce::OrderStatus.shipping
       end

        def update
          @customer = Breeze::Commerce::Customer.find params[:id]
          if @customer.update_attributes(params[:customer])
            flash[:notice] = "The customer was saved. <a href=\"#{admin_store_customer_path(@customer)}\">View your changes</a>, <a href=\"#{admin_store_customers_path}\">return to the list of customers</a>, or close this message to continue editing."
            redirect_to edit_admin_store_customer_path(@customer)
          else
            render :action => "edit"
          end
        end
        
        def destroy
         @customer = Breeze::Commerce::Customer.find(params[:id])
         @customer.update_attributes(:archived => true)
         @customer_count = Breeze::Commerce::Customer.unarchived.count
        end

      private

        def sort_method
          %w[total first_name last_name email].include?(params[:sort]) ? params[:sort] : "last_name"
        end
        
        def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
        end

      end
    end
  end
end
