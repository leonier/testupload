class AddPublicToUptests < ActiveRecord::Migration
  def change
    add_column :uptests, :public, :integer
  end
end
