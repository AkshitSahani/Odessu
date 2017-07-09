class RemoveExtraInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_items, :name, :string
    remove_column :order_items, :price, :integer
    remove_column :order_items, :description, :string
    remove_column :wish_list_items, :item_name, :string
    remove_column :wish_list_items, :item_price, :integer
    remove_column :wish_list_items, :item_description, :string
  end
end
