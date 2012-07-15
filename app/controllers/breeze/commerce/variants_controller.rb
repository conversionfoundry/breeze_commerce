# module Breeze
#   module Commerce
#     class VariantsController < Breeze::Commerce::Controller
#       def new
#         @variant = product.variants.new
#       end
# 
#       def create
#         @variant = product.variants.create params[:variant]
#       end
# 
#       def edit
#         @variant = product.variants.find params[:id]
#       end
# 
#       def update
#         @variant = product.variants.find params[:id]
#         @variant.update_attributes params[:variant]
#       end
# 
#       private
# 
#       def product
#         @product ||= Product.find params[:product_id]
#       end
#     end
#   end
# end