class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :recipient
      t.timestamp :date
      t.string :subject
      t.references :user

      t.timestamps
    end
    add_index :reminders, :user_id
  end
end
