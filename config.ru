require 'rubygems'
require 'bundler/setup'
require 'walters_api'
require 'rack/cors'
#use Rack::Cors do
#  allow do
#    origins '*'
#    resource '/*', :headers => :any, :methods => :get
#  end
#end
 
run WaltersApi::Server
