class ChangeTutorialstoProducts < ActiveRecord::Migration[5.0]
  def change
    drop_table :tutorials
    drop_table :products
    create_table :products do |t|
      t.string :tops
      t.string :tops_href
      t.string :dresses
      t.string :dresses_href
      t.string :bottoms
      t.string :bottoms_href
      t.string :outwear
      t.string :outwear_href
      t.string :swimwear
      t.string :swimwear_href
      t.string :link
      t.string :link_href
      t.string :shorts
      t.string :skirts
      t.string :leggings
      t.string :activewear
      t.string :jumpsuit
      t.string :jumpsuit_href
      t.string :name
      t.string :picture_src
      t.string :priceall
      t.string :pricebefore
      t.string :priceafter
      t.string :description1
      t.string :description2
      t.string :description3
      t.string :description4
      t.string :description5
      t.string :color
      t.string :size
      t.string :itemcode
    end
  end
end
