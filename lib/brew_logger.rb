require 'active_support/logger'

module BrewLogger
  LOGGER = ActiveSupport::Logger.new(
    Rails.root.join('log/brew_status.log'),
    10,            # Keep 10 rotated log files
    10.megabytes   # Each file size limit
  )

  LOGGER.level = Logger::DEBUG

  LOGGER.formatter = proc do |severity, datetime, _progname, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] BREW_LOG | #{severity}: #{msg}\n"
  end
end
