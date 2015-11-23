class AddRegnumToSocieties < ActiveRecord::Migration
  def change
    add_column :societies, :regnum, :integer
  end
end
