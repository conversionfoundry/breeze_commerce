module Breeze
  module Commerce
    class CategoriesController < Breeze::Commerce::Controller
      def index
        @categories = Category.ordered
        respond_to do |format|
          format.html
          format.json { render :json => @categories.map{|c| [:id => c.id, :name => c.name] } }
        end
      end

      def new
        @category = Category.new
      end

      def create
        @category = Category.create params[:category].merge({ :position => Category.max(:position) + 1 })
      end
      
      def edit
        @category = Category.find params[:id]
      end
      
      def update
        @category = Category.find params[:id]
        @category.update_attributes params[:category]
      end
      
      def reorder
        params[:category].each_with_index do |id, index|
          Category.find(id).update_attributes :position => index
        end
        render :nothing => true
      end
      
      def destroy
        @category = Category.find params[:id]
        @category.try :destroy
      end
    end
  end
end
