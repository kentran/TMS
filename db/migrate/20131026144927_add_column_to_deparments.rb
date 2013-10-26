class AddColumnToDeparments < ActiveRecord::Migration
  def change
  	add_column :departments, :deadline, :date
  end
end
