class ProjectReference < ActiveRecord::Base
  belongs_to :project
  attr_accessible :content, :reference_source, :reference_url
  
  validates :reference_source, presence: true
  validates :reference_url, :format => URI::regexp(%w(http https))
end
