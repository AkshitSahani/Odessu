class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.string :name
      t.integer :price
      t.string :description

      t.timestamps
    end
  end
end
