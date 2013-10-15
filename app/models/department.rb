class Department < ActiveRecord::Base
  belongs_to :university
  has_many :users

  attr_accessible :name, :format
end
