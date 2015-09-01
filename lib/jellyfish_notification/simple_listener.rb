module JellyfishNotification
  class SimpleListener
    def project_creation_successful(project)
      JellyfishMailer.project_creation_successful(project).deliver_now
    end
  end
end
