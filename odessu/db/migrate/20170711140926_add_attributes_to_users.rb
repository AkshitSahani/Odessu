class AddAttributesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address, :string
    add_column :users, :age_range, :string
    add_column :users, :height, :string
    add_column :users, :weight, :string
    add_column :users, :bust, :string
    add_column :users, :hip, :string
    add_column :users, :waist, :string
    add_column :users, :account_type, :string
    add_column :users, :tops_store, :string
    add_column :users, :tops_size, :string
    add_column :users, :tops_store_fit, :string
    add_column :users, :bottoms_store, :string
    add_column :users, :bottoms_size, :string
    add_column :users, :bottoms_store_fit, :string
    add_column :users, :bra_size, :string
    add_column :users, :bra_cup, :string
    add_column :users, :body_shape, :string
    add_column :users, :tops_fit, :string
    add_column :users, :preference, :string
    add_column :users, :bottoms_fit, :string
    add_column :users, :birthdate, :string
    add_column :users, :advertisement_source, :string
  end
end
