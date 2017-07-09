class AddProductIdToWishListItem < ActiveRecord::Migration[5.0]
  def change
    add_column :wish_list_items, :product_id, :integer 
  end
end
