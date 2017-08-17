# frozen_string_literal: true

require 'thor'
require 'softlayer/cli/vpn'
require 'softlayer/cli/servers'
require 'softlayer/cli/networks'

module Softlayer
  class CLI < Thor
    VERSION = '0.0.1'

    desc 'vpn SUBCOMMAND ...ARGS', 'manage VPN connections'
    subcommand 'vpn', VPN

    desc 'servers SUBCOMMAND ...ARGS', 'manage servers'
    subcommand 'servers', Servers

    desc 'networks SUBCOMMAND ...ARGS', 'manage networks'
    subcommand 'networks', Networks
  end
end
