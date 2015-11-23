class ModifySocietytypeColumn < ActiveRecord::Migration
  def change
  	rename_column :societies, :type, :catalogue
  end
end
