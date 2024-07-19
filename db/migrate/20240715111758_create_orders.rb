class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :order_no, null: false
      t.integer :amount, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.datetime :paid_at
      t.timestamps
    end

    unless index_exists?(:orders, :user_id)
      add_index :orders, :user_id
    end

    unless index_exists?(:orders, :order_no, unique: true)
      add_index :orders, :order_no, unique: true
    end
  end
end
