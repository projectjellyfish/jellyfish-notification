Rails.application.configure do
  config.action_mailer.delivery_method = :smtp unless ENV['JELLYFISH_DELIVERY_METHOD'] != 'smtp'
  config.action_mailer.delivery_method = :test if Rails.env == 'test'
  config.action_mailer.smtp_settings = {
    address:              ENV['JELLYFISH_SMTP_ADDRESS'],
    port:                 ENV['JELLYFISH_SMTP_PORT'],
    user_name:            ENV['JELLYFISH_SMTP_USER_NAME'],
    password:             ENV['JELLYFISH_SMTP_PASSWORD'],
    authentication:       ENV['JELLYFISH_SMTP_AUTHENTICATION'],
    enable_starttls_auto: ENV['JELLYFISH_SMTP_ENABLE_STARTTLS_AUTO']
  }
end
