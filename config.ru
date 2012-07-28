require 'rubygems'
require 'bundler'

Bundler.require

require './lib/walters_api/server'
run WaltersApi::Server
