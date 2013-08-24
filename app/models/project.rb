class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :project_files
  has_many :project_references
  attr_accessible :abstract, :created, :title, :version

  validates :title, presence: true
end
