class AddBwHtypeandInseamToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bust_waist_hip_inseam_type, :string
    add_column :users, :inseam, :string
  end
end
