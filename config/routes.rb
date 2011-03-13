Rails.application.routes.draw do
  scope "admin/commerce", :module => "breeze/commerce", :name_prefix => "admin_commerce" do
    root :to => "commerce#index"
    controller :commerce do
    
    end
  
    resources :products

    resources :categories do
      collection do
        put :reorder
      end
    end    
  end
end

