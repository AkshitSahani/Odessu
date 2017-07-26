class AddMoreToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :delivery_type, :string
    add_column :orders, :shipping_address, :string
    add_column :orders, :delivery_address, :string
  end
end
