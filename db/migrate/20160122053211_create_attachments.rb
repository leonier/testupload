class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :uptest
      t.references :postthread

      t.timestamps
    end
    add_index :attachments, :uptest_id
    add_index :attachments, :postthread_id
  end
end
