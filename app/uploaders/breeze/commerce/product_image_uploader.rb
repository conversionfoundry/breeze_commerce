# encoding: utf-8
module Breeze
  module Commerce
    class ProductImageUploader < CarrierWave::Uploader::Base

      # Include RMagick or MiniMagick support:
      include CarrierWave::RMagick
      # include CarrierWave::MiniMagick

      # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
      include Sprockets::Helpers::RailsHelper
      include Sprockets::Helpers::IsolatedHelper

      FULL_SIZE  = [ 544, 292 ].freeze unless defined?(FULL_SIZE)
      FEATURE_SIZE = [ 240, 204 ].freeze unless defined?(FEATURE_SIZE)
      LISTING_SIZE = [ 192, 162 ].freeze unless defined?(LISTING_SIZE)
      THUMB_SIZE = [ 50, 50 ].freeze unless defined?(THUMB_SIZE)
      BREEZE_THUMB_SIZE = [ 128, 128 ].freeze unless defined?(BREEZE_THUMB_SIZE)

      # Choose what kind of storage to use for this uploader:
      storage :file
      # storage :fog

      # Override the directory where uploaded files will be stored.
      # This is a sensible default for uploaders that are meant to be mounted:
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      # Provide a default URL as a default if there hasn't been a file uploaded:
      # def default_url
      #   # For Rails 3.1+ asset pipeline compatibility:
      #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
      #
      #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
      # end

      # Process files as they are uploaded:
      # process :scale => [200, 300]
      #
      # def scale(width, height)
      #   # do something
      # end

      # Create different versions of your uploaded files:
      # version :thumb do
      #   process :scale => [50, 50]
      # end

      version :full do
        process :resize_to_limit => FULL_SIZE
      end

      version :feature do
        process :resize_to_fill => FEATURE_SIZE
      end

      version :listing do
        process :resize_to_fill => LISTING_SIZE
      end

      version :thumbnail do
        process :resize_to_fill => THUMB_SIZE
      end

      version :breeze_thumb do
        process :resize_to_limit => BREEZE_THUMB_SIZE
      end

      # Add a white list of extensions which are allowed to be uploaded.
      # For images you might use something like this:
      # def extension_white_list
      #   %w(jpg jpeg gif png)
      # end

      # Override the filename of the uploaded files:
      # Avoid using model.id or version_name here, see uploader/store.rb for details.
      # def filename
      #   "something.jpg" if original_filename
      # end

      before :cache, :capture_size_before_cache 
      before :retrieve_from_cache, :capture_size_after_retrieve_from_cache 

      protected
  
      def capture_size_before_cache(new_file)
        capture_image_size!(new_file.path || new_file.file.tempfile.path)
      end
    
      def capture_size_after_retrieve_from_cache(cache_name)
        capture_image_size!(@file.path)
      end
      
      def capture_image_size!(path)
        model.image_width, model.image_height = `identify -format "%wx%h" #{path}`.split(/x/)
      end

    end
  end
end





# require 'carrierwave/mongoid'

# # encoding: utf-8
# module Breeze
#   module Commerce
#     class ProductImageUploader < CarrierWave::Uploader::Base
#       include CarrierWave::RMagick

#       # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
#       include Sprockets::Helpers::RailsHelper
#       include Sprockets::Helpers::IsolatedHelper

#       FULL_SIZE  = [ 544, 292 ].freeze unless defined?(FULL_SIZE)
#       FEATURE_SIZE = [ 240, 204 ].freeze unless defined?(FEATURE_SIZE)
#       LISTING_SIZE = [ 192, 162 ].freeze unless defined?(LISTING_SIZE)
#       THUMB_SIZE = [ 50, 50 ].freeze unless defined?(THUMB_SIZE)
    
#       storage :file
    
#       # def store_path(for_file = filename)
#       #   File.join *[version_name ? "#{model.folder}#{version_name}" : "#{model.folder}", full_filename(for_file)].compact
#       #   # File.join *[version_name ? "images/galleries/#{model.gallery.title}/#{version_name}" : "images/galleries/#{model.gallery.title}", full_filename(for_file)].compact
#       # end
      
#       # def store_dir
#       #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
#       # end

#       # Provide a default URL as a default if there hasn't been a file uploaded:
#       # def default_url
#       #   # For Rails 3.1+ asset pipeline compatibility:
#       #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
#       #
#       #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
#       # end

#       # def full_filename(for_file)
#       #   for_file
#       # end

#       # def extension_white_list
#       #   %w(jpg jpeg gif png)
#       # end

#       version :full do
#         process :resize_to_limit => FULL_SIZE
#       end

#       version :feature do
#         process :resize_to_fill => FEATURE_SIZE
#       end

#       version :listing do
#         process :resize_to_fill => LISTING_SIZE
#       end

#       version :thumbnail do
#         process :resize_to_fill => THUMB_SIZE
#       end



#       # before :cache, :capture_size_before_cache 
#       # before :retrieve_from_cache, :capture_size_after_retrieve_from_cache 

#       protected
  
#       def capture_size_before_cache(new_file)
#         capture_image_size!(new_file.path || new_file.file.tempfile.path)
#       end
    
#       def capture_size_after_retrieve_from_cache(cache_name)
#         capture_image_size!(@file.path)
#       end
      
#       def capture_image_size!(path)
#         model.image_width, model.image_height = `identify -format "%wx%h" #{path}`.split(/x/)
#       end
#     end
#   end
# end

