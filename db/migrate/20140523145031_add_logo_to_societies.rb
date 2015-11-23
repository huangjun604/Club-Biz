class AddLogoToSocieties < ActiveRecord::Migration
  def change
  	add_column :societies, :logo_filename, :string
  	add_column :societies, :logo_type, :string
  	add_column :societies, :logo_data, :binary
  end
end
