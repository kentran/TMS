class ChangeColumnLevel < ActiveRecord::Migration
  def up
    change_column :users, :level, :string
  end

  def down
  end
end
