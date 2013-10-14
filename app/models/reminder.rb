class Reminder < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :recipient, :subject, :status
end
