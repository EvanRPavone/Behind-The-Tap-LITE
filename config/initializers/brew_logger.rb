# config/initializers/brew_logger.rb

# Custom logger for brew-related logs
BREW_LOGGER = ActiveSupport::Logger.new(Rails.root.join('log/brew_status.log'))

# Set log level
BREW_LOGGER.level = Logger::INFO

# Format the logger output
BREW_LOGGER.formatter = proc do |severity, datetime, _progname, msg|
  "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
end

# Safely attach the custom logger to Rails logger
Rails.logger.extend ActiveSupport::Logger.broadcast(BREW_LOGGER) if Rails.logger.respond_to?(:broadcast)
