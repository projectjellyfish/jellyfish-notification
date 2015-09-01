module JellyfishNotification
  class SimpleListener
    def publish_project_creation(project)
      JellyfishMailer.publish_project_creation(project).deliver_now
    end
  end
end
