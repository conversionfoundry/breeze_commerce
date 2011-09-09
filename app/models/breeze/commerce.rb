module Breeze
  module Commerce
    PERMALINK = /^(\/[^\/\.]+)(\/[^\/\.]+)?(\/[^\/\.]+)?$/.freeze unless defined?(PERMALINK)
  end
end

# module Breeze
#   module Blog
#     ARCHIVE_PART  = /(\d{4})(\/(\d{1,2})(\/(\d{1,2})(\/([^\/]+))?)?)?/.freeze unless defined?(ARCHIVE_PART)
#     CATEGORY_PART = /category\/([^\/\.]+)/.freeze unless defined?(CATEGORY_PART)
#     TAG_PART      = /tag\/([^\/\.]+)/.freeze unless defined?(TAG_PART)
#     PREVIEW_PART  = /draft\/([^\/\.]+)/.freeze unless defined?(PREVIEW_PART)
#     PERMALINK     = /(\/(#{ARCHIVE_PART}|#{CATEGORY_PART}|#{TAG_PART}|#{PREVIEW_PART}))?(\.\w+)?$/.freeze unless defined?(PERMALINK)
#   end
# end

