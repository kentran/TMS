class AddColumnToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :sender, :string
  	add_column :notifications, :is_view, :boolean
  	add_column :notifications, :content, :string, :default => "My files are ready!"
  end
end
