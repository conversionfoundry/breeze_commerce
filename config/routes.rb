Breeze::Engine.routes.draw do  

  namespace "admin" do  
    namespace "store", :module => "commerce", :name_prefix => "admin_store" do
      root :to => "store#index"
      
      controller :store do
        post :setup_default
        get :settings
        put :settings     
      end
  
      resources :products do
        resources :variants do
          resources :variant_images
        end
        resources :properties
        resources :product_images
        resources :product_relationships
        put       :mass_update, :on => :collection
        delete    :mass_destroy, :on => :collection
      end

      resources :orders do
        resources :line_items
        resources :notes
        resources :payments
        # post :remove_item, :on => :member # TODO: SHouldn't need this
      end

      resources :categories do
        collection do
          put :reorder
        end

      end    

      resources :coupons

      resources :customers

      resources :shipping_methods do
        post :make_default, :on => :member
      end
  
    end

  end

  namespace "store", :module => "commerce", :name_prefix => "admin_store" do
    devise_for :customer, :class_name => "Breeze::Commerce::Customer", :module => :devise, :controllers => {:sessions => "breeze/commerce/sessions"}
  end

  scope :module => "commerce" do        

    resources :orders do
      resources :line_items
      get :checkout, :on => :collection
      post :populate, :on => :collection
      post :remove_item, :on => :member
      get :thankyou, :on => :member
      get :payment_failed, :on => :member
    end

    # TODO: There should be no index access here. Customers should only be allowed to manage their own accounts
    resources :customers 
    
    # TODO: Only need index here
    resources :variants do
      get 'filter', :on => :collection
    end

    # TODO: Not sure why this wasn't here. It needs to work with the normal Breeze hierarchy.
    # resources :products
     
    get 'cart', :to => 'orders#edit', :as => :cart
    get 'checkout', :to => 'orders#checkout', :as => :checkout
    put 'submit_order', :to => 'orders#submit_order', :as => :submit_order

  end

end
