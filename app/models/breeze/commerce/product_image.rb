# TODO: Why doesn't this inherit from Breeze::Content::Image?
module Breeze
  module Commerce
    class ProductImage < Breeze::Content::Asset
      field :image_width, :type => Integer
      field :image_height, :type => Integer
      field :position, :type => Integer

      #embedded_in :product, :class_name => "Breeze::Commerce::Product", :inverse_of => :images
      belongs_to_related :product, :class_name => "Breeze::Commerce::Product"

      mount_uploader :file, Breeze::Commerce::ProductUploader, :mount_on => :file

      before_update :reprocess_file

      scope :ordered, order_by(:position.asc)

      protected
      
        def reprocess_file
          unless crop.blank?

            file.versions.each do |name, v|
              if name.to_s == crop[:version]
                
                file.manipulate! do |image|
                v.manipulate! do |img|
                  img = image.crop(crop[:x].to_i, crop[:y].to_i, crop[:w].to_i, crop[:h].to_i)
                  img.resize!(crop[:width].to_i, crop[:height].to_i)
                  img
                end
                image
                end
              end
            end
          end
        end
    end
  end
end

