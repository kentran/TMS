class Department < ActiveRecord::Base
  belongs_to :university
  attr_accessible :name
end
