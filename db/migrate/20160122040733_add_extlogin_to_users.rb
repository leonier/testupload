class AddExtloginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :isexternal, :boolean
    add_column :users, :external_type, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :datetime
  end
end
