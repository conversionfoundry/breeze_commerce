def remove_old_orders
  Breeze::Commerce::Order.abandoned.destroy_all
end

namespace :breeze do
  namespace :commerce do
    desc "Delete orders that are more than two weeks old and never went to checkout"
    task :clean_orders => :environment do
      remove_old_orders
    end
  end
end