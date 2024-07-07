class AddAncestryToCategory < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:categories, :ancestry)
      add_column :categories, :ancestry, :string
    end

    unless index_exists?(:categories, :ancestry)
      add_index :categories, :ancestry
    end
  end
end
