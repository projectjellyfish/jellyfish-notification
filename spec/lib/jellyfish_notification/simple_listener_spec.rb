class Project
  include Wisper::Publisher

  def self.mock
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

  def save
    publish('publish_project_creation', Project.mock, '')
  end
end

describe JellyfishNotification::SimpleListener do
  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context 'project created' do
    it 'should publish project creation to send admin notification' do
      # CREATE DUMMY LISTENER - FOLLOWING WISPER RSPEC EXAMPLE AT https://github.com/krisleech/wisper/blob/master/spec/lib/integration_spec.rb
      listener = double('listener')

      # SET EXPECTATION THAT LISTENER WILL RECEIVE PROJECT CREATION SUCCESSFUL BROADCAST
      expect(listener).to receive(:publish_project_creation)

      # GENERATE NEW PROJECT
      project = Project.new

      # SUBSCRIBE JELLYFISH MAILER LISTENER TO PROJECT
      project.subscribe(listener)

      # VERIFY THAT NO OTHER EMAILS ARE QUEUED
      expect(ActionMailer::Base.deliveries.count).to eq(0)

      # SAVE PROJECT TO TRIGGER PROJECT CREATE NOTIFICATION
      project.save

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
