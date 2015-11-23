class AddTicketnumToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ticketnum, :integer
  end
end
