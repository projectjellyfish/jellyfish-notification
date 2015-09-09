module JellyfishNotification
  class SimpleListener
    # IF ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true') THEN QUEUE WITH DELAYED JOBS ELSE DELIVER NOW
    def publish_project_create(response, recipients, projects_url)
      project_creator = recipients[:project_creator]
      project_approvers = recipients[:project_approvers]
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        JellyfishMailer.delay.publish_project_create_confirmation(response, project_creator, projects_url)
        JellyfishMailer.delay.publish_project_create_approvers(response, project_approvers, projects_url)
      else
        JellyfishMailer.publish_project_create_confirmation(response, project_creator, projects_url).deliver_now
        JellyfishMailer.publish_project_create_approvers(response, project_approvers, projects_url).deliver_now
      end
    end

    def publish_project_approval_update(project, recipients, project_url)
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        JellyfishMailer.delay.publish_project_approval_update(project, recipients, project_url)
      else
        JellyfishMailer.publish_project_approval_update(project, recipients, project_url).deliver_now
      end
    end

    def publish_order_create(order, recipients, orders_url)
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        JellyfishMailer.delay.publish_order_create(order, recipients, orders_url)
      else
        JellyfishMailer.publish_order_create(order, recipients, orders_url).deliver_now
      end
    end
  end
end
