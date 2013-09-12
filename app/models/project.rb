class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :before_add => :validates_user
  has_many :project_files
  has_many :project_references
  attr_accessible :abstract, :created, :title, :version

  validates :title, presence: true

  def validates_user(user)
  	raise ActiveRecord::Rollback if self.users.include? user
  end
end
