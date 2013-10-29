class ChangeColumnNameProjectFiles2 < ActiveRecord::Migration
	def change
		rename_column :project_files, :primary_files, :primary_file
	end
end
