class AddColumnToProjectReferences < ActiveRecord::Migration
  def change
  	add_column :project_references, :author, :string
  	add_column :project_references, :publisher, :string
  	add_column :project_references, :year, :string
  end
end
