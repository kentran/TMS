class CreateProjectReferences < ActiveRecord::Migration
  def change
    create_table :project_references do |t|
      t.string :reference_source
      t.string :reference_url
      t.text :content
      t.references :project

      t.timestamps
    end
    add_index :project_references, :project_id
  end
end
