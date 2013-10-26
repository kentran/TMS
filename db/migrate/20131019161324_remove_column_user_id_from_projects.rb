class RemoveColumnUserIdFromProjects < ActiveRecord::Migration
	def change
		remove_column :projects, :user_id
		add_column :projects, :version, :string
	end
end
