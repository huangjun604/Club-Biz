class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :content
      t.integer :society_id

      t.timestamps
    end
  end
end
