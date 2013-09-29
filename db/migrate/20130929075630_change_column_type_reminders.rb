class ChangeColumnTypeReminders < ActiveRecord::Migration
	def change
		change_column :reminders, :date, :date
	end
end
