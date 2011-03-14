module Breeze
  module Commerce
    class CategoriesController < Breeze::Commerce::Controller

      def index
        @categories = Category.all
      end

      def create
        @category = Category.create params[:category]
      end
      
      def edit
        @category = blog.categories.find params[:id]
      end
      
      def update
        @category = blog.categories.find params[:id]
        @category.update_attributes params[:category]
      end
      
      def reorder
        params[:category].each_with_index do |category_id, i|
          blog.categories.find(category_id).update_attributes :position => i
        end
        render :nothing => true
      end
      
      def destroy
        @category = blog.categories.find params[:id]
        @category.try :destroy
      end
    end
  end
end
