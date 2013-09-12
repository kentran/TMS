class AddIndexProjectsUsers < ActiveRecord::Migration
	def change
		add_index :projects_users, [:project_id, :user_id], :unique => true, :name => "by_project_and_user"
	end
end
