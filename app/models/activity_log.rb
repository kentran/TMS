class ActivityLog < ActiveRecord::Base
  attr_accessible :action, :browser, :controller, :ip_addr, :note, :params, :user_id
end
