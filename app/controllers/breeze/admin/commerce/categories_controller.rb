module Breeze
  module Admin
    module Commerce
      class CategoriesController < Breeze::Admin::Commerce::Controller
        def index
          @categories = store.categories #.ordered
          #@categories = @categories.where(:name => /#{params[:q]}/) if params[:q]
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
          # if @category.save
          #   redirect_to admin_store_categories_path
          # else
          #   render :action => "new"
          # end
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
