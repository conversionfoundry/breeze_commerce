# module Breeze
#   module Admin
#     module Commerce
#       class CommerceController < Breeze::Admin::Commerce::Controller
#         def index
#         end
#       
#         def setup_default
#           @store = Store.new :title => "Store", :parent_id => Breeze::Content::NavigationItem.root.first.try(:id)
#           @store.save!
#           redirect_to admin_store_root_path
#         end
#       
#         def switch
#           session[:store_id] = params[:store]
#           redirect_to :action => "index"
#         end
#       
#         def new_spam_strategy
#         
#         end
#       
#         def settings
#           if request.put?
#             if store.update_attributes params[:store]
#               redirect_to admin_store_settings_path
#             else
#               render :action => "settings"
#             end
#           end
#         end
#       end
#     end
#   end
# end
