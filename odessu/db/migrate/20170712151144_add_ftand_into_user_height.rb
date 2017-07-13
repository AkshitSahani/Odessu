class AddFtandIntoUserHeight < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :height, :string
    add_column :users, :height_ft, :integer
    add_column :users, :height_in, :integer
    add_column :users, :height_cm, :integer
  end
end
