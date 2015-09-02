Rails.application.configure do
  config.action_mailer.delivery_method = :test
  config.action_mailer.smtp_settings = {
    address:              'smtp.foo.com',
    port:                 '587',
    user_name:            'foobar',
    password:             'foobar',
    authentication:       'plain',
    enable_starttls_auto: 'true'
  }
  config.action_mailer.default_params = {
    from: 'tester@foo.com',
    to:   'tested@foo.com'
  }
end
