module JellyfishNotification
  class JellyfishMailer < ActionMailer::Base
    default from: ENV['JELLYFISH_SMTP_DEFAULT_SENDER']

    def project_creation_successful(project)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = project
      mail(template_path: 'jellyfish_mailer', to: ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'], subject: "Project  #{project.name.to_s.upcase} Creation Notification")
    end
  end
end
