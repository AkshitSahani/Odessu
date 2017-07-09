class CreateOrderReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :order_reviews do |t|
      t.integer :order_id
      t.text :review
      t.integer :user_id

      t.timestamps
    end
  end
end
