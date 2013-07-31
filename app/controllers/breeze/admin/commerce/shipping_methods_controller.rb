module Breeze
  module Admin
    module Commerce
      class ShippingMethodsController < Breeze::Admin::Commerce::Controller
        def index
          @countries = Breeze::Commerce::Shipping::Country.order_by(:name.asc)
          @shipping_methods = Breeze::Commerce::Shipping::ShippingMethod.unarchived.order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
        end

        def new
          @shipping_method = Breeze::Commerce::Shipping::ShippingMethod.new
          @shipping_method_types = [Breeze::Commerce::Shipping::ShippingMethod, Breeze::Commerce::Shipping::ThresholdShippingMethod, Breeze::Commerce::Shipping::TagShippingMethod]
          @tags = Breeze::Commerce::Tag.all
        end

        def create
          sanitize_input params[:shipping_method]
          if params[:shipping_method_type]
            klass = params[:shipping_method_type].camelcase.constantize
            if klass == Breeze::Commerce::Shipping::ShippingMethod
              @shipping_method = Breeze::Commerce::Shipping::ShippingMethod.new params[:shipping_method]
            else
              subclass_params = params[:shipping_method_type].to_s.camelcase.demodulize.underscore
              @shipping_method = klass.new params[:shipping_method].merge params[subclass_params]
            end
          else
            @shipping_method = Breeze::Commerce::Shipping::ShippingMethod.new params[:shipping_method]
          end

          @shipping_method.position = Breeze::Commerce::Shipping::ShippingMethod.count

          if @shipping_method.save
            # Set up variables. The view will handle validation.
            @shipping_methods = Breeze::Commerce::Shipping::ShippingMethod.unarchived.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
            @shipping_method_count = Breeze::Commerce::Shipping::ShippingMethod.unarchived.count
          else
            @shipping_method_types = [Breeze::Commerce::Shipping::ShippingMethod, Breeze::Commerce::Shipping::ThresholdShippingMethod, Breeze::Commerce::Shipping::TagShippingMethod]
          end
        end

        def edit
          @shipping_method = Breeze::Commerce::Shipping::ShippingMethod.find params[:id]
          @shipping_method_types = [Breeze::Commerce::Shipping::ShippingMethod, Breeze::Commerce::Shipping::ThresholdShippingMethod, Breeze::Commerce::Shipping::TagShippingMethod]
          @tags = Breeze::Commerce::Tag.all
        end

        def update
          sanitize_input params[:shipping_method]
          @shipping_method = Breeze::Commerce::Shipping::ShippingMethod.find params[:id]
          if params[:shipping_method_type]
            klass = params[:shipping_method_type].camelcase.constantize
            if klass == Breeze::Commerce::Shipping::ShippingMethod
              @shipping_method.update_attributes(params[:shipping_method])
            else
              subclass_params = params[:shipping_method_type].to_s.camelcase.demodulize.underscore
              @shipping_method.update_attributes( params[:shipping_method].merge params[subclass_params] )
            end
          end
          if @shipping_method.save
            @shipping_methods = Breeze::Commerce::Shipping::ShippingMethod.unarchived.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
          else
          end
        end

        def destroy
          @shipping_method = Breeze::Commerce::Shipping::ShippingMethod.find params[:id]
          @shipping_method.update_attributes(:archived => true)
          # if @shipping_method.is_default?

          # We don't want people to delete the last available shipping method, so we pass this to destroy.js...
          @shipping_method_count = Breeze::Commerce::Shipping::ShippingMethod.unarchived.count
        end

        # TODO: Move this to a mixin, as we'll also use it elsewhere
        def reorder
          params[:shipping_method].each_with_index do |id, index|
            Breeze::Commerce::Shipping::ShippingMethod.find(id).update_attributes :position => index
          end
          render :nothing => true
        end

        protected

        # Deal with common form submission errors automatically, without causing a validation error
        def sanitize_input(shipping_method)
          shipping_method[:price] = shipping_method[:price].gsub(/[^0-9.]/, '') # Strip out any characters except numerals and decimal point (so people can type "$10" instead of "10")
        end


      end
    end
  end
end
