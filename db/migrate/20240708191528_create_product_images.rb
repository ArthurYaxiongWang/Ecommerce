class CreateProductImages < ActiveRecord::Migration[7.1]
  def change
    create_table :product_images do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.integer :weight, default: 0
      t.timestamps
    end
  end
end
