Sidekiq.configure_server do |config|
    config.redis = { url: Rails.application.secrets.redis_server_url }
end

Sidekiq.configure_client do |config|
    config.redis = { url: Rails.application.secrets.redis_server_url }
end