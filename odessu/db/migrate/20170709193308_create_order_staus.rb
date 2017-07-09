class CreateOrderStaus < ActiveRecord::Migration[5.0]
  def change
    create_table :order_staus do |t|
      t.integer :order_id
      t.string :status

      t.timestamps
    end
  end
end
