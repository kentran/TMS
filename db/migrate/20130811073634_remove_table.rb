class RemoveTable < ActiveRecord::Migration
  def up
    drop_table :projects_users
  end

  def down
  end
end
