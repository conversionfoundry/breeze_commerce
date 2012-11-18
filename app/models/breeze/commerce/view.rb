module Breeze
  module Commerce
    class View < Breeze::Content::PageView

      def with_url_params(match)
        dup.tap do |view|
          view.set_url_params(match)
        end
      end

      def set_url_params(match)
      end

      def template
        if content.template.blank?
          "breeze/commerce/#{name}"
        else
          content.template
        end
      end
      
    end
  end
end
