class NotificationsController < ApplicationController
	def index
		@notifications = current_user.notifications
	end

	# Get all the notificaitons sent to current_user
	def index_new
	    # First get all the notifications sent to current user
	    # from all projects related to the current user
	    projects = current_user.projects
	    @notifications = Array.new
	    projects.each do |project|
	    	project.notifications.each do |notification|
	    		if notification.recipient == current_user.email
	    			if notification.is_view == false
	    				notification.update_attributes(:is_view => true)	# update the notification view to true
	    				notification.assign_attributes(:is_view => false)	# but reset it to false before pushing to array
	    			end
	    			@notifications.push notification
	    		end
	    	end
	    end

	    @notifications = @notifications.sort_by! {|obj| obj.created_at}.reverse
	end

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