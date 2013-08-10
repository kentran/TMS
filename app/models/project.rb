class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :abstract, :created, :title, :version

  validates :title, presence: true
end
