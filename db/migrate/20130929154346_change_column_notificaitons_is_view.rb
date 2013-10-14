class ChangeColumnNotificaitonsIsView < ActiveRecord::Migration
	def change
		change_column :notifications, :is_view, :boolean, :default => false
		change_column :notifications, :content, :string, :default => "My files are ready"
	end
end
