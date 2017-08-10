# Softlayer CLI Client

Simple command-line API for Softlayer.

# Usage

After the usual `gem install softlayer-cli`, run `sl help`.

## VPN

Requires ArrayVPN installed at `/usr/local/array_vpn/array_vpnc` and the Lastpass CLI `lpass` available.

* `sl vpn start` launches the ArrayVPN client
* `sl vpn status` checks whether a tun interface exists
* `sl vpn stop` halts the ArrayVPN client

## Server List

`SOFTLAYER_API_USER` and `SOFTLAYER_API_KEY` need to be set as environment variable.

* `sl servers list --tags "deployment:concourse"` shows all machines that are tagged with `deployment:concourse`
* `sl server show 12345` prints details about a single machine with that id
* `sl server show 1.2.3.4` prints details about a single machine with that IP address
