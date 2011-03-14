Rails.application.routes.draw do
  scope "admin/commerce", :module => "breeze/commerce", :name_prefix => "admin_commerce" do
    root :to => "commerce#index"
    controller :commerce do
      get :settings
      put :settings     
    end
  
    resources :products
    resources :orders

    resources :categories do
      collection do
        put :reorder
      end
    end    
  end

  scope :module => "breeze/commerce" do
    resources :orders do
      post :populate, :on => :collection
      post :remove_item
    end
    match 'cart', :to => 'orders#edit', :via => :get, :as => :cart
  end

end

