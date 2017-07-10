class FixOrderStatusTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :order_staus

    create_table :order_statuses do |t|
      t.integer :order_id
      t.string :status

      t.timestamps
    end
  end
end
