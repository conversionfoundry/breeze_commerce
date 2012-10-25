module Breeze
  module Admin
    module Commerce
      class TagsController < Breeze::Admin::Commerce::Controller
        def index
          @tags = Breeze::Commerce::Tag.where(:store_id => store.id).order_by(:created_at.desc).paginate(:page => params[:page], :per_page => 15)
          respond_to do |format|
            format.html
            format.json { render :json => @tags.map{|c| { :id => c.id, :name => c.name } } }
          end
        end

        def new
          @tag = store.tags.new
        end

        def create
          @tag = store.tags.create params[:tag].merge({ :position => (store.tags.max(:position) || 0) + 1 })
        end
                
        def edit
          @tag = store.tags.find params[:id]
        end
        
        def update
          @tag = store.tags.find params[:id]
          @tag.update_attributes params[:tag]
        end
        
        def reorder
          params[:tag].each_with_index do |id, index|
            store.tags.find(id).update_attributes :position => index
          end
          render :nothing => true
        end
        
        def destroy
          @tag = store.tags.find params[:id]
          @tag.try :destroy
        end
      end
    end
  end
end
