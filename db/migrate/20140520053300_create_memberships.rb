class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :society_id
      t.boolean :isadmin

      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :society_id
    add_index :memberships, [:user_id, :society_id], unique:true
  end
end
