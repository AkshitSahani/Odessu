class AddSizeandColortoOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :color, :string
    add_column :order_items, :size, :string
  end
end
