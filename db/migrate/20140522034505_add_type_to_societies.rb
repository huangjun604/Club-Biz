class AddTypeToSocieties < ActiveRecord::Migration
  def change
    add_column :societies, :type, :string
  end
end
