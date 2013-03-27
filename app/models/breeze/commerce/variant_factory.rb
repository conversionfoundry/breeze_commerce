require 'singleton'

module Breeze
  module Commerce

    class VariantFactory
      include Singleton
      
      # Create a variant for each combination of property options
      # e.g. if a product has colours red, green and blue and sizes small, medium and large, this will create a small red variant, a medium red variant, a large red variant, asmall green variant and so forth
      def generate_variants( product, variant_fields )
        option_arrays = product.properties.map{ |property| property.options }
        position = 0
        variants_array = combine_arrays( *option_arrays ) do | *args |
          name = product.name + " " + args.map{ |option| option.name}.join(" ")

          base_sku = variant_fields[:base_sku] || product.slug
          sku_code = base_sku + "_" + args.map{ |option| option.name}.join(" ").downcase.gsub(" ", "_")
          
          variant_fields.merge!(product_id: product.id, name: name, sku_code: sku_code, position: position)
          variant = Breeze::Commerce::Variant.new variant_fields
          
          args.each do |option|
            variant.options << option
          end
          variant.save

          position = position + 1
        end
      end

    private

      def combine_arrays(*arrays)
        if arrays.empty?
          yield
        else
          first, *rest = arrays
          first.map do |x|
            combine_arrays(*rest) {|*args| yield x, *args }
          end.flatten
            #.flatten(1)
        end
      end

    end
    
  end
end
