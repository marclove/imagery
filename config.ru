#!/usr/bin/env rackup -s thin -E none

require 'rubygems'
require 'rack/contrib'
require 'rack/logger'

$: << File.join(File.dirname(__FILE__), 'lib')
require 'imagery'

use Rack::Logger

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
