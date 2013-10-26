class NotificationsController < ApplicationController
	
	#
	# NotificationsController:index
	#
	# Handle GET request to route /users/:user_id/notifications
	# Parameters:
	#
	# Return all Notifications that are sent to and from the current_user
	# to notifications/index.html.erb
	#
	def index
		# All the notifications sent from current_user
		@my_notifications = current_user.notifications

	    # First get all the notifications sent to current user
	    # from all projects related to the current user
	    projects = current_user.projects
	    @notifications = Array.new
	    projects.each do |project|											# find all the project current_user linked to
	    	project.notifications.each do |notification|					# find all the notifications of each project
	    		if notification.recipient == current_user.email 			# get the notification sent to current_user
	    			if notification.is_view == false						# if the notification is not viewed
	    				notification.update_attributes(:is_view => true)	# update the notification view to true
	    				notification.assign_attributes(:is_view => false)	# but reset it to false before pushing to array
	    			end
	    			@notifications.push notification 						# the users will view this object
	    		end
	    	end
	    end

	    # Sort the notifications by created date
	    @notifications = @notifications.sort_by! {|obj| obj.created_at}.reverse
	end

	#
	# NotificationsController:create
	#
	# Handle POST request to route /projects/:project_id/notifications
	# Parameters:
	#
	# Sent a standard notification to the other peers (professors or students)
	# Create a Notfication objects to keep track of the activities
	#
	def create
		@project = Project.find(params[:project_id])
		@recipients = @project.users

		@recipients.each do |recipient|
			# should not sending to oneself
			if recipient == current_user
				next
			end

			# if current user is a professor, he should only send notification to the student
			# if current user is a student, he should send to all professors
			# create the Notification object through User object
			# then push the created Notification object to Project object
			if professor? && recipient.role == 'Student' && recipient.notif_on == true
				UserMailer.notification_email(recipient, @project).deliver
				@notification = current_user.notifications.build(:recipient => recipient.email, :sender => current_user.email)
				@project.notifications << @notification
			elsif student? && recipient.notif_on == true
				UserMailer.notification_email(recipient, @project).deliver
				@notification = current_user.notifications.build(:recipient => recipient.email, :sender => current_user.email)
				@project.notifications << @notification
			end
		end

		redirect_to :back, :notice => "Notifications sent"
	end
end