#!/usr/bin/ruby
require 'thor'
require 'shellwords'
require 'socket'

module Softlayer
  class VPN < Thor
    ACCOUNTS = {
      'staging'    => "Bluemix/Softlayer VPN Password Intern",
      'production' => "Bluemix/Softlayer VPN Password Extern",
      'flintstone' => "Bluemix/Softlayer VPN Flintstone",
    }

    desc "start <profile>", "Starts a VPN connection with <profile>"
    def start(profile)
      %x"echo #{Shellwords.escape(vpn_password(profile))} | /usr/local/array_vpn/array_vpnc -hostname vpn.fra02.softlayer.com -username #{Shellwords.escape(vpn_username(profile))} 2>> #{err_log} >> #{out_log} &"

      if !$?.success? && $?.exited?
        warn "Error: VPN could not be started. Check #{err_log} and #{out_log} for details."
      else
        warn "VPN started with PID #{$?.pid}"
      end
    end

    desc "stop", "Stop the VPN connection"
    def stop
      %x"/usr/local/array_vpn/array_vpnc -stop"
    end

    desc "profiles", "Lists all known VPN profiles"
    def profiles
      puts ACCOUNTS.keys
    end

    desc "status", "Prints the status of the VPN connection"
    def status
      tunnel_interfaces = Socket.getifaddrs.select { |a| a.name =~ /^tun\d+/ && a.addr }

      if tunnel_interfaces.empty?
        warn "No VPN connection"
      else
        tunnel_addresses = tunnel_interfaces.map { |i| [i.name, i.addr.ip_address] }
        puts "VPN connection established via #{Hash[tunnel_addresses]}"
      end
    end

    private

    def vpn_username(profile)
      lastpass(profile, 'username')
    end

    def vpn_password(profile)
      lastpass(profile, 'password')
    end

    def lastpass(profile, attribute)
      %x"lpass show #{Shellwords.escape(account(profile))} --#{attribute}".chomp
    end

    def account(profile)
      ACCOUNTS.fetch(profile)
    end

    def out_log
      "/var/log/sl-vpn.stdout.log"
    end

    def err_log
      "/var/log/sl-vpn.stderr.log"
    end
  end
end
