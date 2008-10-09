$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rexml/document'
require 'rexml/streamlistener'

require 'xmlsp/element'
require 'xmlsp/element_group'
require 'xmlsp/element_listener'
require 'xmlsp/stream_loader'

module XMLSP
end
