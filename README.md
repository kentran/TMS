Set up local development environment
- Clone the project from git@github.com:kentran/TMS.git
- Install Rails 3.2.13 on your local machine. Please follow the instruction to install Rails according to your OS. This instruction assumes you are running on a Mac OSX or Linux machine
- Install MySQL or any database software you desire
- Go into the TMS directory, cd TMS
- Change the database configuration in config/database.yml with the respective database software you have just installed
- bundle install to install all the necessary gem
- rake db:reset to set up and seed the database

Set up Heroku for deployment
- Create an application on heroku
- Follow the instruction here to push your code to heroku: https://devcenter.heroku.com/articles/git

- Go to your heroku dashboard, add the following add-ons to your app:
	+ Heroku Postgres Dev
	+ Heroku Scheduler Standard
	+ Postmark
- After setting up the add-ons, we need to set up a cron job for reminder feature
- Select Scheduler Standard add-ons
- Add the following task: rake reminder:send_reminder
- Set it to run hourly
- Save the changes

- After setting up all the necessary add-ons, set up the database by 
	heroku run rake db:reset
- When the database setup done, you should be able to see the website deployed and log in.

TODO list
- Implement more secure way to upload, download and view files (right now only prevent crawler for public folder)
- Consider split notification attributes to sent_notification and received_notification
- Landing page for admin