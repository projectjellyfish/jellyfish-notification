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
    publish('publish_project_create', Project.mock_project_create_response, '', 'http://fizzbuzz.com')
  end

  def publish_project_approval_update
    publish('publish_project_approval_update', Project.mock_approval_update_project, '', 'http://test.foobar.com')
  end
end

describe JellyfishNotification::SimpleListener do
  after(:each) do
    ActionMailer::Base.deliveries.clear
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

      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        # VERIFY THAT A MAIL WAS SENT UPON PROJECT SAVE AFTER INITIAL CREATE
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      else
        # VERIFY THAT A MAIL WAS SENT UPON PROJECT SAVE AFTER INITIAL CREATE
        expect(ActionMailer::Base.deliveries.count).to eq(1)

        # VERIFY THAT THE SENDER IS THE RECIPIENT SPECIFIED IN DOTENV FILE
        expect(ActionMailer::Base.deliveries.last.from.first).to eq(JellyfishNotification::JellyfishMailer.default_params[:from])
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

      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        # VERIFY THAT A MAIL WAS SENT UPON PROJECT SAVE AFTER INITIAL CREATE
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      else
        # VERIFY THAT A MAIL WAS SENT UPON PROJECT SAVE AFTER INITIAL CREATE
        expect(ActionMailer::Base.deliveries.count).to eq(1)

        # VERIFY THAT THE SENDER IS THE RECIPIENT SPECIFIED IN DOTENV FILE
        expect(ActionMailer::Base.deliveries.last.from.first).to eq(JellyfishNotification::JellyfishMailer.default_params[:from])
      end
    end
  end
end
