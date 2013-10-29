class ChangeColumnNameProjectFiles < ActiveRecord::Migration
	def change
		rename_column :project_files, :primary, :primary_files;
	end
end
