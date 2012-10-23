require 'carrierwave/mongoid'

# TODO: When Breeze assets are improved, change this to inherit from the appropriate Breeze class, priobably Breeze::Content::Image
module Breeze
  module Commerce
    class ProductImage #< Breeze::Content::Asset
      include Mongoid::Document

      attr_accessible :image_width, :image_height, :position, :file, :file_cache, :product_id
      field :image_width, :type => Integer
      field :image_height, :type => Integer
      field :position, :type => Integer

      #embedded_in :product, :class_name => "Breeze::Commerce::Product", :inverse_of => :images
      belongs_to :product, :class_name => "Breeze::Commerce::Product", :inverse_of => :images

      field :file
      mount_uploader :file, Breeze::Commerce::ProductImageUploader#, :mount_on => :file

      # before_update :reprocess_file

      default_scope order_by([:position, :asc])
      scope :ordered, order_by(:position.asc)

      validates_presence_of :file

      after_save :set_as_default

      private

      # If this is the only product image, it should be set as the default image for the product
      def set_as_default
        unless product.default_image
          product.default_image = self
          product.save
        end
      end

      # protected
      
      #   def reprocess_file
      #     # unless crop.blank?

      #     #   file.versions.each do |name, v|
      #     #     if name.to_s == crop[:version]
                
      #     #       file.manipulate! do |image|
      #     #       v.manipulate! do |img|
      #     #         img = image.crop(crop[:x].to_i, crop[:y].to_i, crop[:w].to_i, crop[:h].to_i)
      #     #         img.resize!(crop[:width].to_i, crop[:height].to_i)
      #     #         img
      #     #       end
      #     #       image
      #     #       end
      #     #     end
      #     #   end
      #     # end
      #   end
    end
  end
end

