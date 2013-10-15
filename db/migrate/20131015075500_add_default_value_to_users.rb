class AddDefaultValueToUsers < ActiveRecord::Migration
  def change
  	add_column :departments, :format, :text
  end
end
