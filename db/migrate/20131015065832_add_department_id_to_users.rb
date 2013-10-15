class AddDepartmentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :department_id, :integer
    add_index :users, :department_id
    add_index :users, :university_id
    remove_column :users, :university
    remove_column :users, :department
  end
end
