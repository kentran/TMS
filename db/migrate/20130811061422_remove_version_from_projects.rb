class RemoveVersionFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :version
  end

  def down
    add_column :projects, :version, :string
  end
end
