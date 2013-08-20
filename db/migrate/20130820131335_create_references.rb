class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :source
      t.string :link
      t.text :content
      t.references :project

      t.timestamps
    end
    add_index :references, :project_id
  end
end
