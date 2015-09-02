module JellyfishNotification
  include ActionView::Helpers

  class JellyfishMailer < ActionMailer::Base
    default from: ENV['JELLYFISH_SMTP_DEFAULT_SENDER']

    def publish_project_creation(response, recipients)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = JSON.parse(response.body).to_h
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Creation Notification: #{@project['name'].to_s.upcase}")
    end
  end
end
