class AddInseamToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :predicted_inseam, :float
  end
end
