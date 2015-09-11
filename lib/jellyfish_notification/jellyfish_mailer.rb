module JellyfishNotification
  include ActionView::Helpers

  class JellyfishMailer < ActionMailer::Base
    default from: ENV['JELLYFISH_SMTP_DEFAULT_SENDER']

    def publish_project_create_confirmation(project, recipients)
      @project = project
      @project_url = (Rails.env != 'test') ? (Rails.application.routes.url_helpers.project_url project) : ('http://localhost:3000/api/v1/projects/' + project.id.to_s)
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Create Notification: #{@project['name'].to_s.upcase}") unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end

    def publish_project_create_approvers(project, recipients)
      @project = project
      @project_url = (Rails.env != 'test') ? (Rails.application.routes.url_helpers.project_url project) : ('http://localhost:3000/api/v1/projects/' + project.id.to_s)
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Create Notification: #{@project['name'].to_s.upcase}") unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end

    def publish_project_approval_update(project, recipients)
      @project = project
      @project_url = (Rails.env != 'test') ? (Rails.application.routes.url_helpers.project_url project) : ('http://localhost:3000/api/v1/projects/' + project.id.to_s)
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: "Project Approval Notification: #{@project.name.to_s.upcase}") unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end

    def publish_order_create(order, recipients)
      @order = order
      @order_url = (Rails.env != 'test') ? (Rails.application.routes.url_helpers.order_url order) : ('http://http://localhost:3000/order-history/' + order.id.to_s)
      recipients = ENV['JELLYFISH_SMTP_DEFAULT_RECIPIENT'] if recipients.empty?
      mail(template_path: 'jellyfish_mailer', to: recipients, subject: 'Order Create Notification') unless ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
    end
  end
end
