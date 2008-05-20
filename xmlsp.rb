$: << File.expand_path(File.join(File.dirname(__FILE__),"/lib"))
module XMLSP;end

require 'rexml/document'
require "rexml/streamlistener"

require 'xml_element'
require 'xml_element_group'
require 'item_listener'
require 'xml_stream_loader'
