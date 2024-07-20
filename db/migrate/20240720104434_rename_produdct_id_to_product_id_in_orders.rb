class RenameProdudctIdToProductIdInOrders < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :produdct_id, :product_id
  end
end
