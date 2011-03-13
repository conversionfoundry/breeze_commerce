module Breeze
  module Blog
    class CommentsController < Breeze::Blog::Controller
      def index
        if request.xhr?
          @comments = blog.comments.send(params[:tab]).descending(:created_at).paginate(:page => params[:page] || 1)
          render :partial => "comments", :locals => { :comments => @comments }, :layout => false
        else
          @comments = blog.comments.descending(:created_at)
        end
      end
      
      def new
        @comment = new_comment
      end
      
      def create
        @comment = new_comment
        @comment.attributes = params[:comment]
        @comment.save
      end
      
      def approve
        comment.try :publish!
        render :action => :change
      end
      
      def spam
        comment.try :spam!
        render :action => :change
      end
      
      def mass_update
        @comments = blog.comments.find params[:comment_ids]
        @comments.each do |comment|
          comment.update_attributes params[:comment]
        end
      end
      
      def mass_destroy
        @comments = blog.comments.find params[:comment_ids]
        @comments.map &:destroy
      end
      
      def destroy
        comment.try :destroy
      end
      
    protected
      def comment
        @comment ||= blog.comments.find params[:id]
      end
      
      def new_comment
        if params[:comment] && params[:comment][:parent_id]
          Comment.reply_to blog.comments.find params[:comment][:parent_id], params[:comment]
        else
          blog.comments.build(params[:comment])
        end.with_author(current_user)
      end
    end
  end
end