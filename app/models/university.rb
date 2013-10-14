class University < ActiveRecord::Base
	has_many :departments
  	attr_accessible :description, :name
end
