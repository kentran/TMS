class UserMailer < ActionMailer::Base
  default from: "admin@tms.com"

  def welcome_email(user)
    @user = user
    @sign_in_url = 'http://localhost:3000/accounts/sign_in'
    @edit_account_url = 'http://localhost:3000/accounts/edit'
    mail(to: @user.email, subject: 'Welcome to TMS')
  end
end
