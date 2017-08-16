# frozen_string_literal: true

require 'spec_helper'
require 'softlayer/cli/servers'

describe 'sl servers list' do
  subject(:servers) { Softlayer::Servers.new }
  let(:list) { [] }

  before do
    allow(servers).to receive(:servers).and_return(list)
  end

  context 'the list of servers is empty' do
    it 'prints a warning to stderr' do
      expect { servers.list }.to output(/No servers found/).to_stderr
      expect { servers.list }.to_not output.to_stdout
    end
  end

  context 'the list of servers has some entries' do
    let(:server_11) { double }
    let(:server_42) { double }

    before do
      list << server_11
      list << server_42

      allow(list).to receive(:get).with(11).and_return(server_11)
      allow(server_11).to receive(:id).and_return(11)
      allow(server_11).to receive(:name).and_return('server_11')
      allow(server_11).to receive(:private_ip_address).and_return('127.0.0.11')
      allow(server_11).to receive(:datacenter).and_return('Springfield')
      allow(server_11).to receive(:tags).and_return(['Simpsons', 'Manhattan'])

      allow(list).to receive(:get).with(42).and_return(server_42)
      allow(server_42).to receive(:id).and_return(42)
      allow(server_42).to receive(:name).and_return('server_42')
      allow(server_42).to receive(:private_ip_address).and_return('127.0.0.42')
      allow(server_42).to receive(:datacenter).and_return('Shelbyville')
      allow(server_42).to receive(:tags).and_return(['Simpsons', 'Jebediah'])
    end

    it 'prints the id of the server to stdout' do
      expect { servers.list }.to output(/^\| 11/).to_stdout
      expect { servers.list }.to output(/^\| 42/).to_stdout
    end

    it 'prints the name of the server to stdout' do
      expect { servers.list }.to output(/ \| server_11/).to_stdout
      expect { servers.list }.to output(/ \| server_42/).to_stdout
    end

    it 'prints the private IP address of the server to stdout' do
      expect { servers.list }.to output(/ \| 127.0.0.11/).to_stdout
      expect { servers.list }.to output(/ \| 127.0.0.42/).to_stdout
    end

    it 'prints the datacenter of the server to stdout' do
      expect { servers.list }.to output(/ \| Springfield/).to_stdout
      expect { servers.list }.to output(/ \| Shelbyville/).to_stdout
    end

    it 'prints the tags of the server to stdout' do
      expect { servers.list }.to output(/ \| Simpsons, Manhattan/).to_stdout
      expect { servers.list }.to output(/ \| Simpsons, Jebediah/).to_stdout
    end
  end
end
