class AddPredictionsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :predicted_hip, :float
    add_column :users, :predicted_waist, :float
    add_column :users, :predicted_bust, :float
  end
end
