class ApplicationMailer < ActionMailer::Base
  default from: Setting.general.email_user_name
  layout 'mailer'
end
