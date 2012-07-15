module Breeze
  module Admin
    module Commerce
      class CustomersController < Breeze::Admin::Commerce::Controller
        def index
          @customers = store.customers.all
        end

        def new
          @customer = store.customers.new
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

      end
    end
  end
end
