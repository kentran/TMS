class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.string :file_name
      t.references :user
      t.references :project

      t.timestamps
    end
    add_index :project_files, :user_id
    add_index :project_files, :project_id
  end
end
