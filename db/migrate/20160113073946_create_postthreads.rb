class CreatePostthreads < ActiveRecord::Migration
  def change
    create_table :postthreads do |t|
      t.integer :user_id
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
