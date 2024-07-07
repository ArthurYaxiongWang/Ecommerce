class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :weight, default: 0
      t.integer :products_counter, default: 0
      t.string :ancestry
      t.timestamps
    end

    add_index :categories, [:title]
  end
end
