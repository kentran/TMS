class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :recipient
      t.references :user
      t.references :project

      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :project_id
  end
end
