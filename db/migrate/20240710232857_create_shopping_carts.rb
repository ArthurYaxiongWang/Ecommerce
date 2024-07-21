class CreateShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_carts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :user_uuid
      t.integer :amount
      t.timestamps
    end

    add_index :shopping_carts, [:user_uuid]
  end
end
