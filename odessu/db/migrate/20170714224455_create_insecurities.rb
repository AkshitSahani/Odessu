class CreateInsecurities < ActiveRecord::Migration[5.0]
  def change
    create_table :insecurities do |t|
      t.integer :user_id
      t.string :insecurity_top
      t.string :insecurity_bottom

      t.timestamps
    end
  end
end
