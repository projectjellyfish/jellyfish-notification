class Project
  include Wisper::Publisher

  def self.mock_approval_update_project
    # MOCK PROJECT AS IT EXISTS IN JF CONTROLLER
    OpenStruct.new(
      id: 1,
      name: 'foo',
      description: nil,
      cc: nil,
      staff_id: nil,
      img: nil,
      created_at: Time.zone.now,
      updated_at: Time.zone.now,
      deleted_at: nil,
      status: 0,
      approval: 0,
      archived: nil,
      spent: BigDecimal(0.0, 2),
      budget: BigDecimal(1.0, 2),
      start_date: Time.zone.now,
      end_date: (Time.zone.now + 7.days))
  end

  def self.mock_project_create_response
    # MOCK JSON RESPONSE FROM THE JF PROJECT CONTROLLER
    OpenStruct.new(body:  "{
                   \"id\": 1,
                   \"name\": \"foo\",
                   \"description\": null,
                   \"cc\": null,
                   \"staff_id\": null,
                   \"img\": null,
                   \"created_at\": \"#{Time.zone.now}\",
                   \"updated_at\": \"#{Time.zone.now}\",
                   \"deleted_at\": null,
                   \"status\": 0,
                   \"approval\": 0,
                   \"archived\": null,
                   \"spent\": #{BigDecimal(0.0, 2)},
                   \"budget\": #{BigDecimal(1.0, 2)},
                   \"start_date\": \"#{Time.zone.now}\",
                   \"end_date\": \"#{Time.zone.now + 7.days}\"}")
  end

  def publish_project_create
    recipients = { project_approvers: 'admin@foobar.com', project_creator: 'user@foobar.com' }
    publish('publish_project_create', Project.mock_project_create_response, recipients, 'http://www.foobar.com/projects')
  end

  def publish_project_approval_update
    publish('publish_project_approval_update', Project.mock_approval_update_project, '', 'http://www.foobar.com/projects/1')
  end
end

class Order
  include Wisper::Publisher

  def self.mock_order_create
    # MOCK ORDER AS IT EXISTS IN JF CONTROLLER
    OpenStruct.new(
      id: 10,
      staff_id: 1,
      engine_response: nil,
      active: nil,
      created_at: '2015-09-03T19:52:32.391Z',
      updated_at: '2015-09-03T19:52:32.391Z',
      options: nil,
      deleted_at: nil,
      total: 0.0,
      order_items: [
        OpenStruct.new(
          id: 22,
          order_id: 10,
          cloud_id: nil,
          product_id: 1,
          service_id: nil,
          provision_status: nil,
          created_at: '2015-09-03T19:52:32.393Z',
          updated_at: '2015-09-03T19:52:32.393Z',
          deleted_at: nil,
          project_id: 1,
          miq_id: nil,
          uuid: nil,
          setup_price: 0.0,
          hourly_price: 0.026,
          monthly_price: 0.0,
          payload_request: nil,
          payload_acknowledgement: nil,
          payload_response: nil,
          status_msg: nil,
          project: Project.mock_approval_update_project,
          product:
            OpenStruct.new(
              id: 1,
              name: 'AWS Small EC2',
              description: 't2.small EC2',
              active: true,
              img: 'products/aws_ec2.png',
              created_at: '2015-09-03T19:51:14.145Z',
              updated_at: '2015-09-03T19:51:14.145Z',
              deleted_at: nil,
              setup_price: 0.0,
              hourly_price: 0.026,
              monthly_price: 0.0,
              product_type: OpenStruct.new(name: 'AWS Fog Infrastructure'))
        ),
        OpenStruct.new(
          id: 23,
          order_id: 10,
          cloud_id: nil,
          product_id: 8,
          service_id: nil,
          provision_status: nil,
          created_at: '2015-09-03T19:52:32.400Z',
          updated_at: '2015-09-03T19:52:32.400Z',
          deleted_at: nil,
          project_id: 1,
          miq_id: nil,
          uuid: nil,
          setup_price: 0.0,
          hourly_price: 0.034,
          monthly_price: 0.0,
          payload_request: nil,
          payload_acknowledgement: nil,
          payload_response: nil,
          status_msg: nil,
          project: Project.mock_approval_update_project,
          product:
            OpenStruct.new(
              id: 8,
              name: 'Small MySQL',
              description: 't2.small MySQL',
              active: true,
              img: 'products/aws_rds.png',
              created_at: '2015-09-03T19:51:14.145Z',
              updated_at: '2015-09-03T19:51:14.145Z',
              deleted_at: nil,
              setup_price: 0.0,
              hourly_price: 0.034,
              monthly_price: 0.0,
              product_type: OpenStruct.new(name: 'AWS Fog Infrastructure')))])
  end

  def publish_order_create
    publish('publish_order_create', Order.mock_order_create, '', 'http://www.foobar.com/order-history')
  end
end

describe JellyfishNotification::SimpleListener do
  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context 'order create' do
    it 'should publish order create and send notification' do
      # CREATE DUMMY LISTENER - FOLLOWING WISPER RSPEC EXAMPLE AT https://github.com/krisleech/wisper/blob/master/spec/lib/integration_spec.rb
      listener = double('listener')

      # SET EXPECTATION THAT LISTENER WILL RECEIVE PROJECT APPROVAL UPDATE BROADCAST
      expect(listener).to receive(:publish_order_create)

      # GENERATE NEW PROJECT
      order = Order.new

      # SUBSCRIBE JELLYFISH MAILER LISTENER TO PROJECT
      order.subscribe(listener)

      # VERIFY THAT NO OTHER EMAILS ARE QUEUED
      expect(ActionMailer::Base.deliveries.count).to eq(0)

      # TRIGGER ORDER CREATE NOTIFICATION
      order.publish_order_create

      # VERIFY MAIL WAS SENT AFTER ORDER CREATE EVENT
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        expect(ActionMailer::Base.deliveries.count).to eq(0) if !ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
      else
        expect(ActionMailer::Base.deliveries.count).to eq(1) if !ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
      end
    end
  end

  context 'project approval updated' do
    it 'should publish project approval update and send notification' do
      # CREATE DUMMY LISTENER - FOLLOWING WISPER RSPEC EXAMPLE AT https://github.com/krisleech/wisper/blob/master/spec/lib/integration_spec.rb
      listener = double('listener')

      # SET EXPECTATION THAT LISTENER WILL RECEIVE PROJECT APPROVAL UPDATE BROADCAST
      expect(listener).to receive(:publish_project_approval_update)

      # GENERATE NEW PROJECT
      project = Project.new

      # SUBSCRIBE JELLYFISH MAILER LISTENER TO PROJECT
      project.subscribe(listener)

      # VERIFY THAT NO OTHER EMAILS ARE QUEUED
      expect(ActionMailer::Base.deliveries.count).to eq(0)

      # TRIGGER PROJECT APPROVAL UPDATE NOTIFICATION
      project.publish_project_approval_update

      # VERIFY MAIL WAS SENT AFTER PROJECT APPROVAL UPDATE EVENT
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        expect(ActionMailer::Base.deliveries.count).to eq(0) if !ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
      else
        expect(ActionMailer::Base.deliveries.count).to eq(1) if !ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
      end
    end
  end

  context 'project created' do
    it 'should publish project create and send notification' do
      # CREATE DUMMY LISTENER - FOLLOWING WISPER RSPEC EXAMPLE AT https://github.com/krisleech/wisper/blob/master/spec/lib/integration_spec.rb
      listener = double('listener')

      # SET EXPECTATION THAT LISTENER WILL RECEIVE PROJECT CREATION SUCCESSFUL BROADCAST
      expect(listener).to receive(:publish_project_create)

      # GENERATE NEW PROJECT
      project = Project.new

      # SUBSCRIBE JELLYFISH MAILER LISTENER TO PROJECT
      project.subscribe(listener)

      # VERIFY THAT NO OTHER EMAILS ARE QUEUED
      expect(ActionMailer::Base.deliveries.count).to eq(0)

      # TRIGGER PROJECT CREATE NOTIFICATION
      project.publish_project_create

      # VERIFY MAIL WAS SENT AFTER PROJECT CREATE EVENT
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        expect(ActionMailer::Base.deliveries.count).to eq(0) if !ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
      else
        expect(ActionMailer::Base.deliveries.count).to eq(2) if !ENV['JELLYFISH_SMTP_DEFAULT_SENDER'].nil?
      end
    end
  end
end
