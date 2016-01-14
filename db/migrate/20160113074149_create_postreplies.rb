class CreatePostreplies < ActiveRecord::Migration
  def change
    create_table :postreplies do |t|
      t.integer :postthread_id
      t.integer :user_id
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
