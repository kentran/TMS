class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

  #
  # Record the the activity for activity log
  # 
  # Accepted parameter is a string for the activity
  # description. The activity will be save into the
  # database
  #
  def record_activity(note)
    @activity = ActivityLog.new
    @activity.user_id = current_user.id
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_addr = request.env['REMOTE_ADDR']
    @activity.controller = controller_name 
    @activity.action = action_name
    @activity.params = params.inspect
    @activity.save
  end

  #
  # Checking if the current user who is using the
  # application is a student or not.
  #
  # Return true if current_user is a student
  #
  def student?
    if current_user.role == 'Student'
      return true
    else
      return false
    end
  end

  #
  # Checking if the current user who is using the
  # application is a professor or not.
  #
  # Return true if current_user is a professor
  #
  def professor?
    if current_user.role == 'Professor'
      return true
    else
      return false
    end
  end

  #
  # Checking if the current user who is using the
  # application is an admin or not.
  #
  # Return true if current_user is an admin
  #
  def admin?
    if current_user.role == 'Admin'
      return true
    else
      return false
    end
  end

  #
  # Checking if the current user who is using the
  # application is an admin or not.
  #
  # Return true if current_user is an manager
  #
  def manager?
    if current_user.role == 'Manager'
      return true
    else
      return false
    end
  end
end
