# In production, the full environment isn't loaded, so we need...
require "#{Breeze::Commerce::Engine.root}/app/models/breeze/commerce/order_status.rb"
require "#{Breeze::Commerce::Engine.root}/app/models/breeze/commerce/mixins/archivable.rb"
require "#{Breeze::Commerce::Engine.root}/app/models/breeze/commerce/order.rb"
require "#{Breeze::Commerce::Engine.root}/app/models/breeze/commerce/note.rb"

def remove_old_orders
  puts "#{Time.now} Removing old abandoned orders..."
  deleted_order_count = Breeze::Commerce::Order.abandoned.destroy_all
  puts "#{Time.now} Deleted #{deleted_order_count} orders"
end

namespace :breeze do
  namespace :commerce do
    desc "Delete orders that are more than two weeks old and never went to checkout"
    task :clean_orders => :environment do
      remove_old_orders
    end
  end
end