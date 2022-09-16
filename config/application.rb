require './config/boot'

require 'rails'
require 'active_record/railtie'

Bundler.require(*Rails.groups)

module GitHubEventsCounter
  class Application < Rails::Application
    config.load_defaults 6.0
    config.autoload_paths += [Rails.root.join('app')]
    config.active_record.legacy_connection_handling = false
  end
end
