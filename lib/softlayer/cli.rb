require 'thor'
require "softlayer/vpn"
require "softlayer/servers"

module Softlayer
  class CLI < Thor
    VERSION = "0.0.1"

    desc "vpn SUBCOMMAND ...ARGS", "manage VPN connections"
    subcommand "vpn", VPN

    desc "servers SUBCOMMAND ...ARGS", "manage VPN connections"
    subcommand "servers", Servers
  end
end
