class FixIssuesTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :issues, :issue, :string
    add_column :issues, :issue_top, :string
    add_column :issues, :issue_bottom, :string
  end
end
