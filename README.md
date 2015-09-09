Jellyfish Notification
=======
[![Gem Version](https://badge.fury.io/rb/jellyfish-notification.svg)](http://badge.fury.io/rb/jellyfish-notification)

A notification system for [Project Jellyfish] (https://github.com/projectjellyfish/api). Can be used to send email notifications to users on project create and approval or order create.

#### Installation
Include in Gemfile:
```
  gem 'jellyfish-notification'
```

Run `bundle install`.

Then add mail settings to your `.env` file:
```
  JELLYFISH_ASYNCHRONOUS_DELIVERY     = false
  JELLYFISH_DELIVERY_METHOD           = smtp
  JELLYFISH_SMTP_ADDRESS              = smtp.postmarkapp.com
  JELLYFISH_SMTP_PORT                 = 587
  JELLYFISH_SMTP_USER_NAME            = POSTMARK-SERVER-API-TOKEN
  JELLYFISH_SMTP_PASSWORD             = POSTMARK-SERVER-API-TOKEN
  JELLYFISH_SMTP_AUTHENTICATION       = plain
  JELLYFISH_SMTP_ENABLE_STARTTLS_AUTO = true
  JELLYFISH_SMTP_DEFAULT_RECIPIENT    = recipient@foobar.com
  JELLYFISH_SMTP_DEFAULT_SENDER       = sender@foobar.com
```

**Setting Descriptions**:
- `JELLYFISH_ASYNCHRONOUS_DELIVERY` will send mail asynchronously using Delayed Jobs if set to `true`. By default, the mailer will block until a message is sent.

- `JELLYFISH_DELIVERY_METHOD` specifies the delivery method used by ActionMailer.

- `JELLYFISH_SMTP_ADDRESS` is the address of your SMTP server.

- `JELLYFISH_SMTP_PORT` is the port of your SMTP server.

- `JELLYFISH_SMTP_USER_NAME` is your STMP user name. If sending mail through Postmark, this value will be your POSTMARK-SERVER-API-TOKEN.

- `JELLYFISH_SMTP_PASSWORD` is your STMP password. If sending mail through Postmark, this value will be your POSTMARK-SERVER-API-TOKEN.

- `JELLYFISH_SMTP_AUTHENTICATION` specifies authentication. If sending mail through Postmark, this value can be plain, CRAM-MD5 or TLS .

- `JELLYFISH_SMTP_ENABLE_STARTTLS_AUTO` specifies whether to start TLS automatically.

- `JELLYFISH_SMTP_DEFAULT_RECIPIENT` is the default recipient address.

- `JELLYFISH_SMTP_DEFAULT_SENDER` is the default sender address.

### Usage
The Jellyfish Notification gem has handlers for certain events that occur in the Jellyfish API:
  - Project Create
  - Project Approval
  - Order Create

which can be orchestrated inside of their respective controller using the [Wisper](https://github.com/krisleech/wisper) gem.
```ruby
class OrdersController < ApplicationController
  include Wisper::Publisher
  after_action :publish_order_create, only: [:create]
  ...
  def publish_order_create
    recipients = current_user.email
    orders_url = "#{request.protocol}#{request.host_with_port}/order-history"
    publish(:publish_order_create, @order, recipients, orders_url)
  end
end
```

### License

See [LICENSE](https://github.com/projectjellyfish/jellyfish-notification/blob/master/LICENSE).

Copyright 2015 Booz Allen Hamilton
