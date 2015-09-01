class Project
  include Wisper::Publisher

  def self.instance_params
    OpenStruct.new(id: 1,
                   name: 'foo',
                   description: nil,
                   cc: nil,
                   staff_id: nil,
                   img: nil,
                   created_at: "#{Time.zone.now}",
                   updated_at: "#{Time.zone.now}",
                   deleted_at: nil,
                   status: 0,
                   approval: 0,
                   archived: nil,
                   spent: BigDecimal(0.0, 2),
                   budget: BigDecimal(1.0, 2),
                   start_date: "#{Time.zone.now}",
                   end_date: "#{Time.zone.now + 7.days}")
  end

  def save
    broadcast('project_creation_successful', Project.instance_params)
  end
end

describe JellyfishNotification::SimpleListener do
  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  context 'project created' do
    it 'should trigger admin notification' do
      # CREATE DUMMY LISTENER - FOLLOWING WISPER RSPEC EXAMPLE AT https://github.com/krisleech/wisper/blob/master/spec/lib/integration_spec.rb
      listener = double('listener')

      # SET EXPECTATION THAT LISTENER WILL RECEIVE PROJECT CREATION SUCCESSFUL BROADCAST
      expect(listener).to receive(:project_creation_successful)

      # GENERATE NEW PROJECT
      project = Project.new

      # SUBSCRIBE JELLYFISH MAILER LISTENER TO PROJECT
      project.subscribe(listener)

      # VERIFY THAT NO OTHER EMAILS ARE QUEUED
      expect(ActionMailer::Base.deliveries.count).to eq(0)

      # SAVE PROJECT TO TRIGGER PROJECT CREATE NOTIFICATION
      project.save

      # VERIFY THAT A MAIL WAS SENT UPON PROJECT SAVE AFTER INITIAL CREATE
      expect(ActionMailer::Base.deliveries.count).to eq(1)

      # VERIFY THAT THE SENDER IS THE RECIPIENT SPECIFIED IN DOTENV FILE
      expect(ActionMailer::Base.deliveries.last.from.first).to eq(JellyfishNotification::JellyfishMailer.default_params[:from])
    end
  end
end
