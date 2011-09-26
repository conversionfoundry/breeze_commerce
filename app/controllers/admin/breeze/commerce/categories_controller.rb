module Admin
  module Breeze
    module Commerce
      class CategoriesController < Breeze::Commerce::Controller
        def index
          @categories = store.categories.ordered
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
          @category = store.categories.build params[:category].merge({ :position => (store.categories.max(:position) || 0) + 1 })
          @category.save
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
