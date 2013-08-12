class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string :user_id
      t.string :browser
      t.string :ip_addr
      t.string :controller
      t.string :action
      t.string :params
      t.string :note

      t.timestamps
    end
  end
end
