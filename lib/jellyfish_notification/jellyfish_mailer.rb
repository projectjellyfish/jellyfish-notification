module JellyfishNotification
  include ActionView::Helpers

  class JellyfishMailer < ActionMailer::Base
    default from: ENV['JELLYFISH_SMTP_DEFAULT_SENDER']

    def publish_project_create(response, recipients, project_url)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = JSON.parse(response.body).to_h
      @project_url = project_url
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Create Notification: #{@project['name'].to_s.upcase}")
    end

    def publish_project_approval_update(project, recipients, project_url)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = project
      @project_url = project_url
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Approval Notification: #{@project.name.to_s.upcase}")
    end
  end
end
