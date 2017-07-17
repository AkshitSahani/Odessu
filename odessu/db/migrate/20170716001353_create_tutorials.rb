class CreateTutorials < ActiveRecord::Migration[5.0]
  def change
    create_table :tutorials do |t|
      t.string :Dresses
      t.string :Dresses_href
      t.string :Blouses
      t.string :Blouses_href
      t.string :Jeans
      t.string :Jeans_href
      t.string :Jackets_Outwear
      t.string :Jackets_Outwear_href
      t.string :Jumpsuits_Jumpers
      t.string :Jumpsuits_Jumpers_href
      t.string :Swimsuit
      t.string :Swimsuit_href
      t.string :Link
      t.string :Link_href
      t.string :Garment_Name
      t.decimal :Prices_before_and_after
      t.string :Description1
      t.string :Description2
      t.string :Description3
      t.string :Description4
      t.string :Description5
      t.string :Description6
      t.string :Color
      t.string :Sizes
      t.integer :SKU_code
      t.decimal :Prices_before
      t.decimal :Price_after

      t.timestamps
    end
  end
end
