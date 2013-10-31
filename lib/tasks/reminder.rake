namespace :reminder do
  desc "send email reminder"
  task :send_reminder => :environment do
  	@reminders = Reminder.all(:conditions => ["status = 'Pending' and date < NOW()"])

  	@reminders.each do |reminder|
  		UserMailer.reminder_email(reminder).deliver
  		reminder.update_attributes(:status => "Sent")
  	end
  end

end
