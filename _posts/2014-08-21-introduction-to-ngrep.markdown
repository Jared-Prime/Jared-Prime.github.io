---
layout: post
title: "introduction to `ngrep`"
date: 2014-08-21 00:00:00
preview: ngrep is a utility for filtering and searching network packets
---

The *nix utility program `ngrep` allows you to search and filter network packets. Much like the well-known `grep` tool enables users to search text located in files and `stdin`/`stdout`, `ngrep` performs similar tasks against the operating system's networking interface. In the words of its manpages, `ngrep`

	currently recognizes TCP, UDP and ICMP across Ethernet, PPP, SLIP, FDD and null interfaces, and understands bpf filter logic in the same fashion as more common packet sniffing tools, such as tcpdump(8) and snoop(1)
	
Simply feed `ngrep` a regular expression, and optionally a protocol, interface, and bpf filter, and you can print live networking packets to `stdout`, redirect (`>`) the contents to a file, or pipe (`|`) to another utility. Here's some examples:

## Installation
`ngrep` is intended to be used alongside your standard *nix command-line tooling. Thus, most package repositories are sufficiently up-to-date.

On MacOS, use homebrew:
- `brew install ngrep`

On Debian based systems (eg, Ubuntu), use aptitude:
- `apt-get install ngrep`

On CentOS, use yum:
- `yum install ngrep`

## Basic Usage
- `ngrep -q 'HTTP'`

This command will query all interfaces and protocols for a string match of `'HTTP'`. The `-q` flag will 'quiet' the output by printing only packet headers and relevant payloads. Most of the time, it is best to use 'quiet' output; otherwise, you might as well use `tcpdump` to capture everything. I will use `-q` in all the examples below so nobody cuts-and-pastes from this article and gets flooded with too much data.

## Adding Timestamps
- `ngrep -qt 'HTTP'`

Use the `t` flag to print a timestamp along with the matched information. Use `T` to print the time elapsed between successive matches.

## Reading from pcap
- `ngrep -I network_capture.pcap -qt 'HTTP'`

If you have a network capture file in `.pcap` format, use `-I $FILE` to filter the capture instead of a network interface. This can be handy, for example, if you have a record of a networking event and you need to do a quick analysis without all the bells and whistles of `wireshark`.

## Writing to pcap
- `ngrep -O network_capture.pcap -q 'HTTP'`

Reverse of the above command, using only the `-O` flag will filter against a network interface and copy the matched packets into a capture file in `.pcap` format.

## Reading with byline
- `ngrep -q -Wbyline 'HTTP'`

Linefeeds are printed as linefeeds, making the output pretty and more legible.

## Common bpf filters
A [bpf](http://biot.com/capstats/bpf.html) specifies a rich syntax for filtering network packets based on information such as IP address, IP protocol, and port number.

### IP address

- `ngrep -q 'HTTP' 'host 192.168'` matches all headers containing the string `'HTTP'` sent to or from the ip address starting with `192.168`
- `ngrep -q 'HTTP' 'dst host 192.168'` will do as above, but instead match a destination host
- `ngrep -q 'HTTP' 'src host 192.168'` will do as above, but instead match a source host

### IP protocol

- `ngrep -q 'HTTP' 'tcp'`
- `ngrep -q 'HTTP' 'udp'`
- `ngrep -q 'HTTP' 'icmp'`

### port number

- `ngrep -q 'HTTP' 'port 80'`

Pretty cool! There are many primitives available, but I only really need to use these three. You can combine primitives using boolean connectives `and`, `or` and `not` to really specify what your grepping.

## Summary
`ngrep` is a pretty handy utility allowing search on network interfaces or captures. Anyone familiar with `grep`, `tcpdump`, or `wireshark` will find it very valuable for quick network analyses.
