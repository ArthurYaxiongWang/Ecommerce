class AddUserDefaultAddressId < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :default_address, foreign_key: { to_table: :addresses }
  end
end
