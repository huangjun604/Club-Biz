class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :date
      t.integer :society_id

      t.timestamps
    end
  end
end
