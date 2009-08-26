# Image server configuration file
RACK_ENV    = ENV['RACK_ENV'] || 'development'

$settings = if File.exist?('/etc/imagery/config.yml') 
  YAML.load_file('/etc/imagery/config.yml')  
else
  {}
end

# Upstream Server where the assets live

ORIGIN_SERVER = $settings['origin_server'] || 'shopify.s3.amazonaws.com'


# Middleware configuration
# recommended to be memcached for meta and disk for entities. 

require 'memcached'

ENV['META_STORE']   = 'memcache://127.0.0.1:11211/meta'
ENV['ENTITY_STORE'] = 'file:/mnt/data/cache/rack/body'


# Logging
Logger.current = RequestAwareLogger.new(File.dirname(__FILE__) + "/../log/#{RACK_ENV}.log")
