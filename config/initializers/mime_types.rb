# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
Rack::Mime::MIME_TYPES.merge!({".map" => "text/plain"})
Rack::Mime::MIME_TYPES['.ttf'] = 'font/truetype'
Rack::Mime::MIME_TYPES['.woff'] = 'application/x-font-woff'
Rack::Mime::MIME_TYPES['.svg'] = 'image/svg+xml'
