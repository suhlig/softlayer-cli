#!/usr/bin/ruby
# frozen_string_literal: true
require 'thor'
require 'shellwords'
require 'socket'

module Softlayer
  class VPN < Thor
    ACCOUNTS = {
      'staging'    => 'Bluemix/Softlayer VPN Password Intern',
      'production' => 'Bluemix/Softlayer VPN Password Extern',
      'flintstone' => 'Bluemix/Softlayer VPN Flintstone',
    }.freeze

    class_option 'endpoint', default: 'vpn.fra02.softlayer.com'

    desc 'start <profile>', 'Starts a VPN connection with <profile>'
    def start(profile)
      user = Shellwords.escape(vpn_username(profile))
      password = Shellwords.escape(vpn_password(profile))

      `echo #{password} | /usr/local/array_vpn/array_vpnc -hostname #{options[:endpoint]} -username #{user} 2>> #{err_log} >> #{out_log} &`

      if !$CHILD_STATUS.success? && $CHILD_STATUS.exited?
        warn "Error: VPN could not be started. Check #{err_log} and #{out_log} for details."
      else
        warn "VPN started with PID #{$CHILD_STATUS.pid}"
      end
    end

    desc 'stop', 'Stop the VPN connection'
    def stop
      `/usr/local/array_vpn/array_vpnc -stop`
    end

    desc 'profiles', 'Lists all known VPN profiles'
    def profiles
      puts ACCOUNTS.keys
    end

    desc 'status', 'Prints the status of the VPN connection'
    def status
      tunnel_interfaces = Socket.getifaddrs.select { |a| a.name =~ /^tun\d+/ && a.addr }

      if tunnel_interfaces.empty?
        warn 'No VPN connection'
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
      `lpass show #{Shellwords.escape(account(profile))} --#{attribute}`.chomp
    end

    def account(profile)
      ACCOUNTS.fetch(profile)
    end

    def out_log
      '/var/log/sl-vpn.stdout.log'
    end

    def err_log
      '/var/log/sl-vpn.stderr.log'
    end
  end
end
