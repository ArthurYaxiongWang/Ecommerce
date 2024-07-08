class AddWeightToProductImages < ActiveRecord::Migration[7.1]
  def change
    add_column :product_images, :weight, :integer
  end
end
