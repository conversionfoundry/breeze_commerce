module Breeze
  module Admin
    module Commerce
      class CustomersController < Breeze::Admin::Commerce::Controller
        def index
          @customers = Breeze::Commerce::Customer.unarchived.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
        end

        def new
          @customer = store.customers.new
          @customer.shipping_address ||= Breeze::Commerce::Address.new # Move to model
          @customer.billing_address ||= Breeze::Commerce::Address.new
        end
        
        def create
          @customer = store.customers.build params[:customer]
          if @customer.save
            redirect_to admin_store_customers_path
          else
            render :action => "new"
          end
        end

        def edit
          @customer = store.customers.find params[:id]
          @customer.shipping_address ||= Breeze::Commerce::Address.new
          @customer.billing_address ||= Breeze::Commerce::Address.new
          @billing_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :billing)
          @shipping_statuses = Breeze::Commerce::Store.first.order_statuses.where(:type => :shipping)
       end

        def update
          @customer = store.customers.find params[:id]
          if @customer.update_attributes(params[:customer])
            flash[:notice] = "The customer was saved. <a href=\"#{admin_store_customer_path(@customer)}\">View your changes</a>, <a href=\"#{admin_store_customers_path}\">return to the list of customers</a>, or close this message to continue editing."
            redirect_to edit_admin_store_customer_path(@customer)
          else
            render :action => "edit"
          end
        end
        
        def destroy
         @customer = store.customers.find(params[:id])
         @customer.update_attributes(:archived => true)
         @customer_count = store.customers.unarchived.count
        end

      end
    end
  end
end
