class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :age_range
      t.string :height
      t.string :weight
      t.string :bust
      t.string :hip
      t.string :waist
      t.string :account_type
      t.string :tops_store
      t.string :tops_size
      t.string :tops_store_fit
      t.string :bottoms_store
      t.string :bottoms_size
      t.string :bottoms_store_fit
      t.string :bra_size
      t.string :bra_cup
      t.string :body_shape
      t.string :tops_fit
      t.string :bottoms_fit
      t.string :preference
      t.string :zip_code
      t.string :birthdate
      t.string :advertisement_source

      t.timestamps
    end
  end
end
