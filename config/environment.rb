# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Wemote::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name => 'app18395829@heroku.com',
  :password => 'wdpmhn0t',
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}