ActionMailer::Base.delivery_method = :sendmail 
ActionMailer::Base.smtp_settings = { 
  :address => 'localhost', 
  :domain => Setting.mail_domain, 
  :port => 25 
} 