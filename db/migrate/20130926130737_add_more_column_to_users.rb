class AddMoreColumnToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :notif_on, :boolean, :null => false, :default => true
  	add_column :users, :reminder_on, :boolean, :null => false, :default => true
  	add_column :users, :upload_confirm_on, :boolean, :null => false, :default => false

  	add_column :project_files, :primary, :boolean, :null => false, :default => false

  	add_column :projects, :deadline, :datetime
  end
end