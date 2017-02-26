---
title: manual ethernet setup on arch linux
layout: post-03242013
published: true
tags: [arch-linux-arm, olinuxino]
---

## Manually Setting Ethernet on (arch) linux

There are times when I'm doctoring a system, or helping someone set up there own
system, when I need to manually enable networking. This usually involves being
in a network where I know the gateways and other details of said network.

Here are the three commands necessary to get internet connectivity.

    # Bring the link "up"
    $ sudo ip link set enp0s26u1u2

    # Assign link an ip-address
    $ sudo ip addr add 192.168.1.151/24 dev enp0s26u1u2

    # Assign a default route via the routers ip address
    $ sudo ip route add default via 192.168.1.1

Some Things to Note

* the ip address 192.168.1.151 is arbitrary. The important part is to pick an
   ip address that hasn't been assigned by the router to someone else.

* the `/24` in the second step is vital. Although the command will succeed, the
   network will not work without the `/24`
