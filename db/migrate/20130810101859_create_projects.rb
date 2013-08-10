class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :version
      t.text :abstract
      t.datetime :created
      t.references :user

      t.timestamps
    end
    add_index :projects, :user_id
  end
end
