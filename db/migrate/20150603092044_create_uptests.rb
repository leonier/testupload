class CreateUptests < ActiveRecord::Migration
  def change
    create_table :uptests do |t|
      t.string :filename
      t.datetime :uploadtime

      t.timestamps
    end
  end
end
