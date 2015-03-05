class BaseMailer < ActionMailer::Base
  default from: "水果社 <no-reply@shuiguoshe.com>"
  default charset: "utf-8"
  default content_type: "text/html"
  default_url_options[:host] = Setting.domain
  
  layout 'mailer'
  helper :users
end
