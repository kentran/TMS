class AddColumnToProjectFiles < ActiveRecord::Migration
  def change
  	add_column :project_files, :original_file_name, :string
  end
end
