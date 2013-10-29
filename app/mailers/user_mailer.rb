class UserMailer < ActionMailer::Base
  default from: "admin@governanceforreal.com"

  def welcome_email(user)
    @user = user
    @sign_in_url = 'http://tms-fyp.herokuapp.com/accounts/sign_in'
    @edit_account_url = 'http://tms-fyp.herokuapp.com/accounts/edit'
    mail(to: @user.email, subject: 'Welcome to TMS')
  end

  def notification_email(user, project)
  	@user = user
  	@project = project
  	mail(to: @user.email, subject: 'Project - ' + @project.title + ' - is ready for review')
    @url = "http://tms-fyp.herokuapp.com"
  end

  def reminder_email(reminder)
    @reminder = reminder
    @user = User.find_by_email(@reminder.recipient)
    mail(to: @reminder.recipient, subject: @reminder.subject)
  end
end
