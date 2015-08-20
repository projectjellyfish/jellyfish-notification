module JellyfishNotification
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishNotification
    config.autoload_paths += %W(#{config.root}/lib)
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
