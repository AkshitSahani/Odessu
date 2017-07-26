class FixAddressforUseras < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :city, :string
    add_column :users, :postal_code, :string
    add_column :users, :province, :string
    add_column :users, :buzzer_code, :string
  end
end
