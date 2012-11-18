Breeze::Engine.routes.draw do  

  namespace "admin" do  
    namespace "store", module: "commerce", name_prefix: "admin_store" do
      root to: "store#index"
      
      controller :store do
        post  :setup_default
        post  :set_default_shipping_method
        get   :settings
        put   :settings     
      end
  
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

      resources :orders, except: [:show] do
        resources :line_items, only: [:create, :destroy]
        resources :notes, only: [:create, :destroy]
        resources :payments, only: [:create, :destroy]
      end

      resources :tags, except: [:show] do
        put :reorder, on: :collection
      end

      resources :customers, except: [:show]

      resources :shipping_methods, except: [:show] do
        put :reorder, on: :collection
      end
  
    end

  end

  namespace "store", module: "commerce", name_prefix: "admin_store" do
    devise_for :customer, class_name: "Breeze::Commerce::Customer", module: :devise, controllers: {sessions: "breeze/commerce/sessions"}
  end

  scope module: :commerce do        

    resources :products, only: [:index]

    resources :orders do
      resources :line_items, only: [:update, :destroy]
      get :checkout, on: :collection
      post :populate, on: :collection
      get :thankyou, on: :member
      get :payment_failed, on: :member
    end

    resources :customers, except: [:index, :show]
    
    get 'variants/filter', to: 'variants#filter', as: :filter_variants
     
    get 'cart', to: 'orders#edit', as: :cart
    get 'checkout', to: 'orders#checkout', as: :checkout
    put 'submit_order', to: 'orders#submit_order', as: :submit_order

  end

end
