class RemindersController < ApplicationController
	def index
		@reminders = current_user.reminders
	end

	def create
	    @reminder = current_user.reminders.create(params[:reminder])
	    
	    if @reminder.save
	      	record_activity("created new reminder: " + @reminder.id.to_s)
	      	redirect_to user_reminders_path(current_user), :notice => "reminder created successfully"
	    else
	      	redirect_to user_reminders_path(current_user), :alert => "reminder has failed to create for some reason"
	    end
	end

	def edit
		@reminder = Reminder.find(params[:id])

		respond_to do |format|
			format.js {}
			format.json { render json: @reminder }
		end
	end

	def update

	end

	def destroy
		@reminder = Reminder.find(params[:id])
		@reminder.destroy

		redirect_to :back, :alert => "A reminder has been removed"
	end
end
