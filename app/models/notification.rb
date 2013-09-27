class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :recipient
end
