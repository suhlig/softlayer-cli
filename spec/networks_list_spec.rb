# frozen_string_literal: true

require 'spec_helper'
require 'softlayer/cli/networks'

# rubocop:disable Metrics/BlockLength
describe 'sl networks list' do
  subject(:networks) { Softlayer::Networks.new }
  let(:list) { [] }

  before do
    allow(networks).to receive(:networks).and_return(list)
  end

  context 'the list of networks is empty' do
    it 'prints a warning to stderr' do
      expect { networks.list }.to output(/No networks found/).to_stderr
      expect { networks.list }.to_not output.to_stdout
    end
  end

  context 'the list of networks has some entries' do
    let(:network_11) { double }
    let(:network_42) { double }

    before do
      list << network_11
      list << network_42

      allow(list).to receive(:get).with(11).and_return(network_11)
      allow(network_11).to receive(:id).and_return(11)
      allow(network_11).to receive(:name).and_return('network_11')
      allow(network_11).to receive(:tags).and_return(['Spider', 'Kumonga'])

      allow(list).to receive(:get).with(42).and_return(network_42)
      allow(network_42).to receive(:id).and_return(42)
      allow(network_42).to receive(:name).and_return('network_42')
      allow(network_42).to receive(:tags).and_return(['Spider', 'Aragog'])
    end

    it 'prints the id of the network to stdout' do
      expect { networks.list }.to output(/^\| 11/).to_stdout
      expect { networks.list }.to output(/^\| 42/).to_stdout
    end

    it 'prints the name of the network to stdout' do
      expect { networks.list }.to output(/ \| network_11/).to_stdout
      expect { networks.list }.to output(/ \| network_42/).to_stdout
    end

    it 'prints the tags of the network to stdout' do
      expect { networks.list }.to output(/ \| Spider, Kumonga/).to_stdout
      expect { networks.list }.to output(/ \| Spider, Aragog/).to_stdout
    end
  end
end
