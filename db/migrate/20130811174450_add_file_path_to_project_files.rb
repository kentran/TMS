class AddFilePathToProjectFiles < ActiveRecord::Migration
  def change
    add_column :project_files, :file_path, :string
  end
end
