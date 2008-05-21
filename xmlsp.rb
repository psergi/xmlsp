$: << File.expand_path(File.join(File.dirname(__FILE__),"/lib"))
module XMLSP;end

require 'rexml/document'
require "rexml/streamlistener"

require 'element'
require 'element_group'
require 'element_listener'
require 'stream_loader'
