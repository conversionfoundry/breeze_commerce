Breeze::Engine.routes.draw do  

  namespace "admin" do
    # namespace "store" do
  
    namespace "store", :module => "commerce", :name_prefix => "admin_store" do
      root :to => "store#index"
      controller :commerce do
        get :settings
        put :settings     
      end
  
      resources :products do
        resources :variants
        resources :properties
        resources :product_images
        resources :associations
      end

      resources :orders do
        # member do
        #   get :print
        # end
      end

      resources :categories do
        collection do
          put :reorder
        end
      end    

      resources :coupons

      resources :customers

      resources :shipping_methods
  
    end
  end

  scope :module => "commerce" do
  # namespace "store", :module => "commerce", :name_prefix => "store" do
 
    
    resources :orders do
      resources :line_items
      get :checkout, :on => :collection
      post :populate, :on => :collection
      post :remove_item, :on => :member
      get :thankyou, :on => :collection
    end
    
    # TODO: Not sure why this wasn't here. It needs to work with the normal Breeze hierarchy.
    # resources :products
     
    match 'cart', :to => 'orders#edit', :via => :get, :as => :cart
    match 'checkout', :to => 'orders#checkout', :via => :get, :as => :checkout
    match 'submit_order', :to => 'orders#submit_order', :via => :put, :as => :submit_order
    match 'thankyou', :to => 'orders#thankyou', :via => :get, :as => :thankyou


  end

end
