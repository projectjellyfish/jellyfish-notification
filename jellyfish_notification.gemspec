$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_notification/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-notification'
  s.version     = JellyfishNotification::VERSION
  s.authors     = ['mafernando']
  s.email       = ['fernando_michael@bah.com']
  s.homepage    = 'http://www.projectjellyfish.org'
  s.summary     = 'Jellyfish Notification Module '
  s.description = 'A module that adds notification support to the Project Jellyfish API'
  s.license     = 'APACHE'
  s.files       = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.add_dependency 'rails'
  s.add_dependency 'dotenv-rails' # to use env vars from jellyfish api
  s.add_dependency 'pg' # to use jellyfish db
  s.add_dependency 'wisper' # enables pub/sub functions
end
