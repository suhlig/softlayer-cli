require 'thor'
require "softlayer/vpn"

module Softlayer
  class CLI < Thor
    VERSION = "0.0.1"

    desc "vpn SUBCOMMAND ...ARGS", "manage VPN connections"
    subcommand "vpn", VPN
  end
end
