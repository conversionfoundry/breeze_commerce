module Breeze
  module Admin
    module Commerce
      class CategoriesController < Breeze::Admin::Commerce::Controller
        def index
          @categories = Breeze::Commerce::Category.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
          respond_to do |format|
            format.html
            format.json { render :json => @categories.map{|c| { :id => c.id, :name => c.name } } }
          end
        end

        def new
          @category = store.categories.new
        end

        def create
          @category = store.categories.create params[:category].merge({ :position => (store.categories.max(:position) || 0) + 1 })
        end
                
        def edit
          @category = store.categories.find params[:id]
        end
        
        def update
          @category = store.categories.find params[:id]
          @category.update_attributes params[:category]
        end
        
        def reorder
          params[:category].each_with_index do |id, index|
            store.categories.find(id).update_attributes :position => index
          end
          render :nothing => true
        end
        
        def destroy
          @category = store.categories.find params[:id]
          @category.try :destroy
        end
      end
    end
  end
end
