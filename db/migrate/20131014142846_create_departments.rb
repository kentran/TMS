class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.references :university

      t.timestamps
    end
    add_index :departments, :university_id
  end
end
