class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :address
      t.string :store_size
      t.string :type
      t.string :size_min
      t.string :size_max

      t.timestamps
    end
  end
end
