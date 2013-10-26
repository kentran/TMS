class RemindersController < ApplicationController
	#
	# RemindersController:index
	#
	# Handle GET request to route /users/:user_id/reminders
	# Parameters: 
	#
	# Return all pending and sent Reminder objects to reminders/index.html.erb
	#
	def index
		@pending_reminders = current_user.reminders.select { |reminder| reminder.status == 'Pending' }
		@sent_reminders = current_user.reminders.select { |reminder| reminder.status == 'Sent' }
	end

	#
	# RemindersController:create
	#
	# Handle POST request to route /users/:user_id/reminders
	# Parameters: reminder[]
	#
	# Create a new Reminder and redirect to /users/:user_id/reminders
	#
	def create
	    @reminder = current_user.reminders.create(params[:reminder])
	    
	    if @reminder.save
	      	record_activity("created new reminder: " + @reminder.id.to_s)
	      	redirect_to user_reminders_path(current_user), :notice => "reminder created successfully"
	    else
	      	redirect_to user_reminders_path(current_user), :alert => "reminder has failed to create for some reason"
	    end
	end

	#
	# RemindersController:destroy
	#
	# Handle PUT request to route /users/:user_id/reminders
	# Parameters: id (reminder id)
	#
	# Delete a Reminder specified by id and redirect to /users/:user_id/reminders
	#
	def destroy
		@reminder = Reminder.find(params[:id])
		@reminder.destroy

		redirect_to :back, :alert => "A reminder has been removed"
	end
end
