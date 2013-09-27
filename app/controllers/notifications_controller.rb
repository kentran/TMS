class NotificationsController < ApplicationController
	def index
		@notifs = Notification.all
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
			if professor? && recipient.role == 'Student'
				UserMailer.notification_email(recipient, @project).deliver
				@notification = current_user.notifications.build(:recipient => recipient.email)
				@project.notifications << @notification
			elsif student?
				UserMailer.notification_email(recipient, @project).deliver
				@notification = current_user.notifications.build(:recipient => recipient.email)
				@project.notifications << @notification
			end
		end

		redirect_to project_notifications_path
	end
end