class DropColumnFromTableUsers < ActiveRecord::Migration
  def up
    remove_column :users, :level
  end

  def down
  end
end
