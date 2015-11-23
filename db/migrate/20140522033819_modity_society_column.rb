class ModitySocietyColumn < ActiveRecord::Migration
  def change
  	change_table :societies do |t|
  		t.rename :name, :s_name
  		t.rename :email, :website
  	end
  end
end
