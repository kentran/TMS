class Reminder < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :recipient, :subject, :status

  def self.send_scheduled_reminder
  	# @reminders = Reminder.all(:conditions => ["status = 'Pending' and date between NOW() and NOW() + interval 1 day"])

  	# @reminders.each do |reminder|
  	# 	UserMailer.reminder_email(reminder)
  	# 	#reminder.update_attributes(:status => "Sent")
  	# end

  	@reminder = Reminder.find_by_subject('test3')
  	@user = User.find_by_first_name('Ken')
  	UserMailer.welcome_email(@user)
  end
end
