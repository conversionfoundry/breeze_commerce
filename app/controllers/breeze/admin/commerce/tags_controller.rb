module Breeze
  module Admin
    module Commerce
      class TagsController < Breeze::Admin::Commerce::Controller
        def index
          @tags = Breeze::Commerce::Tag.includes(:products)
          respond_to do |format|
            format.html
            format.json { render :json => @tags.map{|c| { :id => c.id, :name => c.name } } }
          end
        end

        def new
          @tag = Breeze::Commerce::Tag.new
        end

        def create
          @tags = Breeze::Commerce::Tag.includes(:products)
          @tag_count = @tags.count
          @tag = Breeze::Commerce::Tag.create params[:tag].merge({ position: @tag_count })
        end
                
        def edit
          @tag = Breeze::Commerce::Tag.find params[:id]
        end
        
        def update
          @tag = Breeze::Commerce::Tag.find params[:id]
          @tag.update_attributes params[:tag]
        end
        
        def reorder
          params[:tag].each_with_index do |id, index|
            Breeze::Commerce::Tag.find(id).update_attributes :position => index
          end
          render :nothing => true
        end
        
        def destroy
          @tag = Breeze::Commerce::Tag.find params[:id]
          @tag.try :destroy
          @tag_count = Breeze::Commerce::Tag.count
        end
      end
    end
  end
end
