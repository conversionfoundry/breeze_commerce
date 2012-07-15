# module Breeze
#   module Commerce
#     class Commerce < Breeze::Content::Page
#       def view_for(controller, request)
#         if controller.admin_signed_in? && request.params[:view]
#           returning views.by_name(request.params[:view]) do |view|
#             view.with_url_params Breeze::Commerce::PERMALINK.match(permalink)
#           end
#         else
#           view_from_permalink request.path
#         end
#       end
# 
#       def method_missing(sym, *args, &block)
#         if sym.to_s =~ /^(.+)_view$/
#           view_name = $1
#           views.detect { |v| v.name == view_name } ||
#             views.build({ :name => view_name}, "Breeze::Commerce::#{view_name.camelize}View".constantize)
#         else
#           super
#         end
#       end
# 
#       def view_from_permalink(permalink)
#         match = Breeze::Commerce::PERMALINK.match(permalink) || {}
#         view = if match[3]  # product
#                   product_view
#                else
#                  index_view
#                end
#         view.with_url_params match
#       end 
# 
#       def self.find_by_permalink(permalink)
#         Rails.logger.debug "find by permalink"
#         if permalink =~ Breeze::Commerce::PERMALINK
#           permalink = $`
#           where(:permalink => permalink).first
#         end
#       end
#     end
#   end
# end
