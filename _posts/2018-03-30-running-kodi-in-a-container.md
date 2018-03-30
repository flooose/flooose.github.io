---
title: running kodi in a linux container
layout: post-03242013
published: true
tags: [systemd, systemd-nspawn, arch linux, kodi]
---


## Running Kodi in a linux Container

Running kodi often means installing add-ons from unknown sources. We don't know
how they work and don't see what they may be secretly doing without telling us.

This is the set up I use to protect myself against that.

### Setup a `systemd-nspawn` Container

The first step is to set up a container in which to run Kodi. I use
`systemd-nspawn` to run my containers, instead of something like `docker`. Since
I'm in arch linux, I can bootstrap an arch linux install with the `pacstrap` command:

    $ mkdir ~/Containers/kodi
    $ sudo pacstrap -i -c -d ~/Containers/kodi base kodi --ignore linux

We don't need the kernel, so we ignore it. Additionally, I install chromium.
This isn't a absolutely necessary, but chromium installs dependencies that allow
sound to work inside the container. I haven't been able to pinpoint which
dependencies those might be and frankly I'm too lazy for that. Installing
chromium also allows me to test the sound quickly by going to youtube or
something.

Now we need to set up the user in the container under which Kodi will run

    $ sudo systemd-nspawn -D ~/Containers/kodi/
    root@kodi # useradd -m chris -u 1000
    root@kodi # ^d

Note, the `uid` of the user in the container has to be the same as the `uid` of
the user on the host; in my case it was 1000. The reasoning behind this will
be addressed in the next section.

### Running the Container

The next step is running Kodi in the container. Before going into details, the
command looks as follows:

    $ sudo systemd-nspawn \
    -D ~/Containers/kodi \
    --bind-ro /run/user/1000/gdm/:/home/chris/mnt \
    --setenv XAUTHORITY=/home/chris/mnt/Xauthority \
    --setenv DISPLAY=$DISPLAY \
    -u chris kodi

In order for the container's graphical programs (in this case Kodi) to connect
to the host's `x`-session, we have to make the logged-in user's `Xauthority` on
the host available in the container. This is done by bind-mounting to
`/home/chris/mnt/Xauthority` in the container and setting an environment
variable to inform the application of this. In order for all this to work, the
permissions of the `XAuthority` have to be in sync, hence, the `uid` in the
container has to be in sync with the `uid` on the host. Finally, use `DISPLAY`
to let the applications know which `$DISPLAY` to use.

Rounding all of this out, we save the above command to a script:

    $ cat ~/bin/kodi
    #! /usr/bin/env bash

    sudo systemd-nspawn \
    -D ~/Containers/kodi \
    --bind-ro /run/user/1000/gdm/:/home/chris/mnt \
    --setenv XAUTHORITY=/home/chris/mnt/Xauthority \
    --setenv DISPLAY=$DISPLAY \
    -u chris kodi

and we're ready to watch some kodi:

    $ kodi

### Notes

For various reasons, I haven't switched from xorg to wayland, but I have tested
this setup on wayland and it did work.

That being said, xorg apparently security issues. There are no assurances that
running kodi and its add-ons in a container will be absolutely secure. This
setup only isolates the process from the file system and hopes that these
add-ons don't take advantage of any xorg-specific vulnerabilities.

As a final note, as seen in the `systemd-nspawn` command, our `Xauthority` lies
in `/run/user/1000/gdm/`, a gdm specific location. I use gnome and gdm and I
have no idea how all of this would look under a different display manager.
