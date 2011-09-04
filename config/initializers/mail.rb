ActionMailer::Base.smtp_settings = {
  :address => "SMPT-SERVER",
  :port => PORT,
  :domain => "DOMAIN",
  :authentication => :login,
  :user_name => "USERNAME",
  :password => 'PASSWORD'
}
