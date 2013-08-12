class CreateUsersProjectsJoinTable < ActiveRecord::Migration
  def up
    create_table :projects_users do |t|
      t.belongs_to :projects
      t.belongs_to :users
    end
  end

  def down
  end
end
