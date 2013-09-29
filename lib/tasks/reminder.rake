namespace :reminder do
  desc "send email reminder"
  task :send_reminder => :environment do
  	Reminder.send_scheduled_reminder
  end

end
