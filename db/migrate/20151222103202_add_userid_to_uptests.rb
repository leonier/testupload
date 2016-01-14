class AddUseridToUptests < ActiveRecord::Migration
  def change
    add_column :uptests, :user_id, :integer
  end
end
