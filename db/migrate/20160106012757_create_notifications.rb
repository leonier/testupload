class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.datetime :date
      t.string :notificationtext

      t.timestamps
    end
  end
end
