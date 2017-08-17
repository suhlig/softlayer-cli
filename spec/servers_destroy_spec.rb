# frozen_string_literal: true

require 'spec_helper'
require 'softlayer/cli/servers'

# rubocop:disable Metrics/BlockLength
describe 'sl servers destroy' do
  subject(:servers) { Softlayer::Servers.new }
  let(:list) { double }

  before do
    allow(servers).to receive(:servers).and_return(list)
  end

  let(:server_11) { double }
  let(:server_42) { double }
  let(:server_47) { double }

  before do
    allow(list).to receive(:get).with(42).and_return(server_42)
    allow(server_42).to receive(:id).and_return(42)
    allow(server_42).to receive(:name).and_return('server_42')
    allow(server_42).to receive(:private_ip_address).and_return('127.0.0.42')
  end

  context 'the server is deletable' do
    before do
      expect(server_42).to receive(:destroy).and_return(true)
    end

    it 'destroys a single server' do
      expect(servers.destroy(42)).to be_truthy
    end

    it 'prints the result to stdout' do
      expect { servers.destroy(42) }.to output(/initiated/).to_stdout
    end
  end

  context 'the server is not deletable' do
    before do
      expect(server_42).to receive(:destroy).and_return(false)
    end

    it 'exits with a non-zero code' do
      expect { servers.destroy(42) }.to raise_error(SystemExit)
    end
  end

  context 'working on multiple servers' do
    before do
      allow(list).to receive(:get).with(11).and_return(server_11)
      allow(server_11).to receive(:id).and_return(11)
      allow(server_11).to receive(:name).and_return('server_11')
      allow(server_11).to receive(:private_ip_address).and_return('127.0.0.11')
    end

    context 'the servers are all destroyable' do
      before do
        expect(server_11).to receive(:destroy).and_return(true)
        expect(server_42).to receive(:destroy).and_return(true)
      end

      it 'destroys multiple servers' do
        expect { servers.destroy(42, 11) }.to_not raise_error
      end

      it 'prints the results to stdout' do
        expect { servers.destroy(42, 11) }.to output(/initiated/).to_stdout
      end
    end
  end
end
