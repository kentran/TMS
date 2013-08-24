class DropTableReferences < ActiveRecord::Migration
  def up
    drop_table :references
  end

  def down
  end
end
