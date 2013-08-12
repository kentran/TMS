class RemoveTableActivityLogs < ActiveRecord::Migration
  def up
    drop_table :activity_logs
  end

  def down
  end
end
