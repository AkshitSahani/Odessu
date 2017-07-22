class AddToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_subscription, :boolean, default: false
    add_column :users, :terms_agreed?, :boolean, default: false
  end
end
