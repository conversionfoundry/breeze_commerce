Rails.application.routes.draw do
  scope "admin/store", :module => "breeze/commerce", :name_prefix => "admin_store" do
    root :to => "store#index"
    controller :commerce do
      get :settings
      put :settings     
    end
  
    resources :products do
      resources :variants
      resources :product_images
    end

    resources :orders do
      member do
        get :print
      end
    end

    resources :categories do
      collection do
        put :reorder
      end
    end    

    resources :coupons
  end

  scope :module => "breeze/commerce" do
    resources :orders do
      resources :line_items
      get :checkout, :on => :collection
      post :populate, :on => :collection
      post :remove_item, :on => :member
      get :thankyou, :on => :collection
    end
    match 'cart', :to => 'orders#edit', :via => :get, :as => :cart
    match 'checkout', :to => 'orders#checkout', :via => :get, :as => :checkout
  end

end

