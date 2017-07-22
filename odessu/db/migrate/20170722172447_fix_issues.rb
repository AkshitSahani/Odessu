class FixIssues < ActiveRecord::Migration[5.0]
  def change
    rename_column :issues, :issue_top, :issue_fit
    rename_column :issues, :issue_bottom, :issue_length
  end
end
