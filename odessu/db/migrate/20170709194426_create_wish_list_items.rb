class CreateWishListItems < ActiveRecord::Migration[5.0]
  def change
    create_table :wish_list_items do |t|
      t.integer :wish_list_id
      t.string :item_name
      t.integer :item_price
      t.string :item_description

      t.timestamps
    end
  end
end
