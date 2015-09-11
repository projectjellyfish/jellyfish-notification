module JellyfishNotification
  class SimpleListener
    # IF 'JELLYFISH_ASYNCHRONOUS_DELIVERY' IS true THEN MAIL GETS ADDED TO DELAYED JOBS
    def publish_project_create(project, current_user)
      project_approvers = Staff.admin.pluck(:email).join(', ')
      project_creator = current_user.email
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        JellyfishMailer.delay.publish_project_create_confirmation(project, project_creator)
        JellyfishMailer.delay.publish_project_create_approvers(project, project_approvers)
      else
        JellyfishMailer.publish_project_create_confirmation(project, project_creator).deliver_now
        JellyfishMailer.publish_project_create_approvers(project, project_approvers).deliver_now
      end
    end

    def publish_project_approval_update(project)
      project_approvers = Staff.admin.pluck(:email).join(', ')
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        JellyfishMailer.delay.publish_project_approval_update(project, project_approvers)
      else
        JellyfishMailer.publish_project_approval_update(project, project_approvers).deliver_now
      end
    end

    def publish_order_create(order, current_user)
      order_creator = current_user.email
      if ENV['JELLYFISH_ASYNCHRONOUS_DELIVERY'] == 'true'
        JellyfishMailer.delay.publish_order_create(order, order_creator)
      else
        JellyfishMailer.publish_order_create(order, order_creator).deliver_now
      end
    end
  end
end
