module Breeze
  module Admin
    module Commerce
      class TagsController < Breeze::Admin::Commerce::Controller
        helper_method :sort_method, :sort_direction

        def index
          @filters = Breeze::Commerce::Tag::FILTERS
          if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
            @tags = Breeze::Commerce::Tag.unscoped.includes(:products).send(params[:show])
          else
            @tags = Breeze::Commerce::Tag.unscoped.includes(:products)
          end  

          @tags = @tags.order_by(sort_method + " " + sort_direction).paginate(:page => params[:page], :per_page => 15)

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

      private

        def sort_method
          %w[name].include?(params[:sort]) ? params[:sort] : "name"
        end
        
        def sort_direction
          %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
        end

      end
    end
  end
end
