class AddWeightTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :weight_type, :string
  end
end
