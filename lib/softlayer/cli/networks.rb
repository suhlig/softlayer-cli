# frozen_string_literal: true

require 'thor'
require 'fog/softlayer'
require 'terminal-table'

module Softlayer
  class Networks < Thor
    # TODO: --format=json with
    # class_option :format

    KNOWN_ATTRIBUTES = %w[id name].freeze

    desc 'list', 'Lists all networks'
    method_options tags: []
    def list
      candidates = if options[:tags] && options[:tags].any?
                     networks.tagged_with(options[:tags])
                   else
                     networks
                   end

      if candidates.empty?
        warn 'No networks found.'
      else
        rows = candidates.map do |s|
          [s.id, s.name, s.tags.map(&:strip).join(', ')]
        end

        puts Terminal::Table.new(headings: ['ID', 'Name', 'Tags'], rows: rows)
      end
    end

    private

    def networks
      @networks ||= Fog::Network.new(
        provider: 'softlayer',
        softlayer_username: ENV.fetch('SOFTLAYER_API_USER'),
        softlayer_api_key: ENV.fetch('SOFTLAYER_API_KEY'),
      ).networks
    end
  end
end
