module JellyfishNotification
  class SimpleListener
    def publish_project_create(response, recipients, project_url)
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        # QUEUE WITH DELAYED JOBS
        JellyfishMailer.delay.publish_project_create(response, recipients, project_url)
      else
        # DELIVER NOW
        JellyfishMailer.publish_project_create(response, recipients, project_url).deliver_now
      end
    end
  end
end
