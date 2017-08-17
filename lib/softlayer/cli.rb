# frozen_string_literal: true

require 'thor'
require 'softlayer/cli/vpn'
require 'softlayer/cli/servers'

module Softlayer
  class CLI < Thor
    VERSION = '0.0.1'

    desc 'vpn SUBCOMMAND ...ARGS', 'manage VPN connections'
    subcommand 'vpn', VPN

    desc 'servers SUBCOMMAND ...ARGS', 'manage servers'
    subcommand 'servers', Servers
  end
end
