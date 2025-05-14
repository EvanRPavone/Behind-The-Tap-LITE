Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'behind-the-tap' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'behind-the-tap' }
end
