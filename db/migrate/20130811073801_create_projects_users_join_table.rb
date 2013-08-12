class CreateProjectsUsersJoinTable < ActiveRecord::Migration
  def up
    create_table :projects_users do |t|
      t.belongs_to :project
      t.belongs_to :user
    end
  end

  def down
  end
end
