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