class AddColumnToReminders < ActiveRecord::Migration
  def change
  	add_column :reminders, :status, :string, :default => "Pending"
  end
end
