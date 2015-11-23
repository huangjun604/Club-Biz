class AddAvatarToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :avator_filename, :string
  	add_column :users, :avator_type, :string
  	add_column :users, :avator_data, :binary
  end
end
