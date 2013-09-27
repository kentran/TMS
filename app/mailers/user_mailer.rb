class UserMailer < ActionMailer::Base
  default from: "admin@governanceforreal.com"

  def welcome_email(user)
    @user = user
    @sign_in_url = 'http://localhost:3000/accounts/sign_in'
    @edit_account_url = 'http://localhost:3000/accounts/edit'
    mail(to: @user.email, subject: 'Welcome to TMS')
  end

  def notification_email(user, project)
  	@user = user
  	@project = project
  	mail(to: @user.email, subject: 'Your project is ready for review')
  end
end
