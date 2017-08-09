#!/usr/bin/ruby
require 'thor'
require 'fog/softlayer'
require 'terminal-table'
require 'ipaddr'

module Softlayer
  # TODO Remove once https://github.com/fog/fog-softlayer/pull/4 was merged
  module Blank
    def blank?
      to_s.empty?
    end
  end

  class Servers < Thor
    # TODO --format=json
    # class_option :format

    desc "list", "Lists all servers"
    method_options tags: []
    def list
      candidates = if options[:tags].any?
                     servers.tagged_with(options[:tags])
                   else
                     servers
                   end

      if candidates.empty?
        warn "No servers found."
      else
        rows = candidates.map do |s|
          [s.id, s.name, s.private_ip_address, s.datacenter, s.tags.map { |t| t.strip }.join(', ') ]
        end

        puts Terminal::Table.new(headings: ['ID', 'Name', 'IP Address', 'Data Center', 'Tags'], rows: rows)
      end
    end

    desc "show", "Show details of a particular server by id or IP address"
    method_option :attribute, desc: 'Print only the value of the given attribute'
    def show(id)
      server = begin
                 IPAddr.new(id)
                 servers.get_by_ip(id.dup.extend(Blank)) #
               rescue
                 servers.get(id)
               end

      if server.nil?
        warn "No server found matching #{id}"
      else
        if options[:attribute]
          begin
            puts server.send(options[:attribute])
          rescue NoMethodError
            warn "No attribute '#{options[:attribute]}' found. Known attributes are: #{attributes.map{|a| a.to_s}.join(', ')}"
          end
        else
          rows = attributes.map do |attribute|
             [attribute, server.send(attribute)]
          end

          puts Terminal::Table.new(headings: ['Attribute', 'Value'], rows: rows)
        end
      end
    end

    private

    def servers
      @servers ||= Fog::Compute.new(
        provider: "softlayer",
        softlayer_username: ENV.fetch('SOFTLAYER_API_USER'),
        softlayer_api_key: ENV.fetch('SOFTLAYER_API_KEY'),
      ).servers
    end

    def attributes
      %i(id name private_ip_address public_ip_address bare_metal created_at
         modify_date datacenter hourly_billing_flag tags ssh_password state)
    end
  end
end
