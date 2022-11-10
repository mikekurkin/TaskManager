class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_USERNAME'] || 'noreply@taskmanager.local'
  layout 'mailer'
end
