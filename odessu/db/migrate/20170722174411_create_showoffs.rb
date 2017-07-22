class CreateShowoffs < ActiveRecord::Migration[5.0]
  def change
    create_table :showoffs do |t|
      t.string :showoff
      t.timestamps
    end
  end
end
