class AddImageToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :image_filename, :string
  	add_column :events, :image_type, :string
  	add_column :events, :image_data, :binary
  end
end
