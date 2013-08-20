class Reference < ActiveRecord::Base
  belongs_to :project
  attr_accessible :content, :link, :source
end
