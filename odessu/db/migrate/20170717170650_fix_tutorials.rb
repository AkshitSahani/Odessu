class FixTutorials < ActiveRecord::Migration[5.0]
  def change
    drop_table :tutorials
  end
end
