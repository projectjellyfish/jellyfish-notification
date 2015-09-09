module JellyfishNotification
  include ActionView::Helpers

  class JellyfishMailer < ActionMailer::Base
    default from: ENV['JELLYFISH_SMTP_DEFAULT_SENDER']

    def publish_project_create_approvers(response, recipients, projects_url)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = JSON.parse(response.body).to_h
      @project_url = projects_url + "/#{@project['id']}"
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Create Notification: #{@project['name'].to_s.upcase}") unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end

    def publish_project_create_confirmation(response, recipients, projects_url)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = JSON.parse(response.body).to_h
      @project_url = projects_url + "/#{@project['id']}"
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Create Notification: #{@project['name'].to_s.upcase}") unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end

    def publish_project_approval_update(project, recipients, project_url)
      # format block causes weirdness, so depending on rails conventions so templates resolve
      @project = project
      @project_url = project_url
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Approval Notification: #{@project.name.to_s.upcase}") unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end

    def publish_order_create(order, recipients, orders_url)
      @order = order
      @order_url = orders_url + "/#{@order.id}"
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: 'Order Create Notification') unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end
  end
end
