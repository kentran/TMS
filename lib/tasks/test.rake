namespace :test do
  desc "send welcome email"
  task :welcome_email => :environment do
  	user = User.find_by_first_name('Ken')
  	UserMailer.welcome_email(user).deliver
  end

  desc "TODO"
  task :notification_email => :environment do
  end

  desc "TODO"
  task :reminder_email => :environment do
  end

end
