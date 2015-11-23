class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :number

      t.timestamps
    end
    add_index :tickets, :user_id
    add_index :tickets, :event_id
  end
end
