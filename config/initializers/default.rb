require 'wisper'

Wisper::GlobalListeners.subscribe(JellyfishNotification::SimpleListener.new)
