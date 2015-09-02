module JellyfishNotification
  class SimpleListener
    def publish_project_creation(response, recipients)
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        # QUEUE WITH DELAYED JOBS
        JellyfishMailer.delay.publish_project_creation(response, recipients)
      else
        # DELIVER NOW
        JellyfishMailer.publish_project_creation(response, recipients).deliver_now
      end
    end
  end
end
