class University < ActiveRecord::Base
	has_many :departments
	has_many :users
  	attr_accessible :description, :name
end
