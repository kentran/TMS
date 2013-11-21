class AddDefaultValueToFormat < ActiveRecord::Migration
  def change
  	change_column :departments, :deadline, :date, :default => Time.now
  end
end
