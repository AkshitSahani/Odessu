class RenameTypeInStores < ActiveRecord::Migration[5.0]
  def change
    remove_column :stores, :type, :string
    add_column :stores, :feature, :string
  end
end
