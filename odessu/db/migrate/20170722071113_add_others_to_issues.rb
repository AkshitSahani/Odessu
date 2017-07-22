class AddOthersToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :other1, :string
    add_column :issues, :other2, :string
  end
end
