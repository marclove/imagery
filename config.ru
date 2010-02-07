#!/usr/bin/env rackup -s thin -E none

require 'rubygems'
# require 'rack/cache'
require 'rack/contrib'

$: << File.join(File.dirname(__FILE__), 'lib')
require 'imagery'
require 'config/env'


use Rack::Config do |env|
  env['imagery.origin_host'] = ORIGIN_SERVER
end


# Add rack sendfile extension.
# Allows us to serve cache hits directly from file system 
# by nginx (big speed boost). read: 
# http://github.com/rack/rack-contrib/blob/5ea5e585a43669842314aa07f1e603be70d6e288/lib/rack/contrib/sendfile.rb


if ENV['NGINX_ACCEL_REDIRECTS']
  STDERR.puts 'Using accel redirect (Shopify config).'
  require 'imagery/middleware/accel_redirect'
  use Imagery::AccelRedirect
else
  use Rack::Sendfile
end

use Rack::ShowExceptions

# 1. Forget about stupid favicons
use Imagery::FaviconFilter

# 2. Log all other incoming requests
# use Imagery::LoggedRequest

# 3. Override server name into something non embarrasing
use Imagery::ServerName

# 4. Content type needs to be present, default to attachment
use Rack::ContentType, "application/octet-stream"

# 5. Serve converted images directly from cache
# use Rack::Cache, 
#   :metastore   => ENV['META_STORE'],
#   :entitystore => ENV['ENTITY_STORE']

# 6. handle PURGE requests 
use Imagery::CachePurge

# 7. See if files already exist on remote host, if so handle them directly
# use Imagery::RemoteProxy

# 8. Otherwise run the image server and produce the missing images
run Imagery::Server.new
