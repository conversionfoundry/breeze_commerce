Breeze::Engine.routes.draw do  

  namespace "admin" do  
    namespace "store", module: "commerce", name_prefix: "admin_store" do
      root to: "orders#index"
      
      resource :store, only: [ :create, :edit, :update]
  
      resources :products, except: [:show] do
        resources :variants, except: [:index, :show] do
          put :reorder, on: :collection
        end
        resources :properties, except: [:index, :show]
        resources :product_images, except: [:index, :show, :edit, :update] do
          put :reorder, on: :collection
        end
        resources :product_relationships, except: [:index, :show]
        put       :mass_update, on: :collection
        delete    :mass_destroy, on: :collection
        post      :set_default_image, on: :member
      end

      resource :variant_factory, only: [:new, :create], controller: "variant_factory"

      resources :orders, except: [:show] do
        resources :line_items, only: [:new, :create, :destroy]
        resources :notes, only: [:create, :destroy]
        resources :payments, only: [:create, :destroy]
      end

      resources :tags, except: [:show] do
        put :reorder, on: :collection
      end

      resources :coupons, except: [:show]
      resources :coupon_codes, only: [:index]
      resources :countries, except: [:index, :show]
      resources :customers, except: [:show]

      resources :shipping_methods, except: [:show] do
        put :reorder, on: :collection
      end
  
    end

  end

  namespace "commerce", module: "commerce" do
    devise_for :customers, class_name: "Breeze::Commerce::Customer"#, module: :devise, controllers: {sessions: "breeze/commerce/sessions"}
  end

  scope module: :commerce do        

    resources :products, only: [:index]
    resources :shipping_methods, only: [:index]

    resources :orders do
      resources :line_items, only: [:update, :destroy, :create]
      put :redeem_coupon, on: :member
      get :checkout, on: :member
      put :submit, on: :member
      get :thankyou, on: :member
      get :payment_failed, on: :member
    end

    resources :customers, except: [:index]
    
    get 'variants/filter', to: 'variants#filter', as: :filter_variants
     
  end

end
