class RemoveCreatedFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :created
  end

  def down
    add_column :projects, :created, :datetime
  end
end
