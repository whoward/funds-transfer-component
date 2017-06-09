#!/usr/bin/env ruby

require_relative '../init'

require 'component_host'

ComponentHost.start('funds-transfer-component') do |host|
  host.register(FundsTransferComponent::Start)
end
