class ChangeParamsFormatInActivityLogs < ActiveRecord::Migration
  def change
    change_column :activity_logs, :params, :text
  end
end
