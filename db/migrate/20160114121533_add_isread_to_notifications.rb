class AddIsreadToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :isread, :integer
  end
end
