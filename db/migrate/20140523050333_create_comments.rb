class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :content

      t.timestamps
    end
	add_index :comments, :user_id
	add_index :comments, :event_id
  end
end
