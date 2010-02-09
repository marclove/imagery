$: << File.join(File.dirname(__FILE__), 'lib')
require 'imagery'

use Rack::ShowExceptions
use Rack::CommonLogger
use Rack::ContentType, "application/octet-stream"

run Imagery::Server.new
