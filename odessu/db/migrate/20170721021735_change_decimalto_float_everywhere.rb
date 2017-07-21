class ChangeDecimaltoFloatEverywhere < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_items, :unit_price, :decimal
    remove_column :order_items, :total_price, :decimal
    add_column :order_items, :unit_price, :float
    add_column :order_items, :total_price, :float
  end
end
