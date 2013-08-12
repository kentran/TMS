class RemoveFilePathFromProjectFiles < ActiveRecord::Migration
  def up
    remove_column :project_files, :file_path
  end

  def down
  end
end
