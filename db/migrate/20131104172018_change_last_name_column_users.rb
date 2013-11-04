class ChangeLastNameColumnUsers < ActiveRecord::Migration
	def change
		change_column :users, :first_name, :string, :default => nil
		change_column :users, :last_name, :string, :default => nil
	end
end
