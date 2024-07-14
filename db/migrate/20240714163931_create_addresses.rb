class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true, null: false
      t.string :address_type
      t.string :contact_name
      t.string :cellphone
      t.string :address
      t.string :zip_code
      t.references :province, foreign_key: true, null: false
      t.timestamps
    end

    add_index :addresses, [:user_id, :address_type]
  end
end

