---
title: yubikeys in guix
layout: post-03242013
published: true
---

## Introduction

I've been playing with guix, as a full system install. In order to do
that, I need certain basics, like access to my github account, which
has two-factor authentication activated.

This is how an absolute beginner got it working.

## tl;dr

For those who know the ins-and-outs of guix system configuration:

- Activate service pcsd
- Install libfido2 and libu2f-host
- Add a udev rule
- Restart

## Activate service pcsd

Add the line to your system config, /etc/config.scm. Since you never want to edit anything in `/etc/`, make a copy

```
$ cp /etc/config.scm ~
```

Now add this line to your services

```
(service pcscd-service-type)
```

A typical vanilla install of guix, with a desktop environment might look as follows

```
(operating-system

  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (host-name "schoko")
  (users (cons* (user-account
                  (name "chris")
                  (comment "chris")
                  (group "users")
                  (home-directory "/home/chris")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
;; ...snip...
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service openssh-service-type)
	    (set-xorg-configuration
              (xorg-configuration
               (keyboard-layout keyboard-layout))))
      %desktop-services))
;; ...snip...
```

so with the new line, your config will look as follows

```
(operating-system

  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (host-name "schoko")
  (users (cons* (user-account
                  (name "chris")
                  (comment "chris")
                  (group "users")
                  (home-directory "/home/chris")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
;; ...snip...
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service openssh-service-type)
	    (service pcscd-service-type)
	    (set-xorg-configuration
              (xorg-configuration
               (keyboard-layout keyboard-layout))))
      %desktop-services))
;; ...snip...
```

At this point you can do `sudo guix system reconfigure ~/config.scm`
and the system should all set with that.

You might want to wait on that though, because you also need to add a
udev rule to your system config. But first install some packages.

## Install relevant packaes

I added the following packages

```
$ guix install libu2f-host libfido2
```

Apparently libu2f-host is deprecated, but as of writing this, I
haven't had the time uninstall it to see if my yubikey still works
without it. That being said, it should be obvious that I'm not even
sure which of these libraries allowed me to bring my yubikey into a
functioning state :/

## Add udev rule

This is how I added the udev rule to the system config. See below for
the necessary changes for your specific needs though.

```
(define %flooose-fido2-rule
  (udev-rule
   "90-flooose-fido2.rules"
   (string-append "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idProduct}==\"0116\", GROUP=\"plugdev\", ATTRS{idVendor}==\"1050\" TAG+=\"uaccess\"" "\n")))

(operating-system

  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (host-name "schoko")
  (users (cons* (user-account
                  (name "chris")
                  (comment "chris")
                  (group "users")
                  (home-directory "/home/chris")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "plugdev")))
                %base-user-accounts))
;; ...snip...
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service openssh-service-type)
	    (service pcscd-service-type)
	    (udev-rules-service 'u2f %flooose-fido2-rule #:groups '("plugdev"))
	    (set-xorg-configuration
              (xorg-configuration
               (keyboard-layout keyboard-layout))))
      %desktop-services))
;; ...snip...
```

So there are three additional parts here:

1. ```(define %flooose-fido2-rule
  (udev-rule
   "90-flooose-fido2.rules"
   (string-append "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idProduct}==\"0116\", GROUP=\"plugdev\", ATTRS{idVendor}==\"1050\" TAG+=\"uaccess\"" "\n")))
```

1. `(udev-rules-service 'u2f %flooose-fido2-rule #:groups '("plugdev"))`
1. The line `'("wheel" "netdev" "audio" "video")` has been changed to `'("wheel" "netdev" "audio" "video" "plugdev")`

For clarity:

- the `define` for the `udev-rule` is can take whatever name you'd
  like. I prefix my variables with `flooose` to help avoid name
  conflicts. This is mostly a habit from my eamcs config stuff.
  
- The line `'("wheel" "netdev" "audio" "video")` has been changed to
  `'("wheel" "netdev" "audio" "video" "plugdev")` adds my user to the
  addtional group `plugdev`.

- `(string-append "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idProduct}==\"0116\", GROUP=\"plugdev\", ATTRS{idVendor}==\"1050\" TAG+=\"uaccess\"" "\n")))`
  comes from cobbling bits together from the internet. You'll
  probably have to change some some of the values, specifically
  `ATTRS{idVendor}` and `ATTS{idProduct}`. I'll explain how to
  get them below. Notice also though, the `GROUP="plugdev"`. This
  has to match, whatever group you assigned your user too above,
  in my case it was `plugdev`. 

### Getting the right values for `idVendor` and `idProduct`

The values for the fields `idVendor` and `idProduct` come from
`lsusb`. Most linxen have this command, so I won't go in getting that
installed.

When I plugged my yubikey into the usb port and ran `lsusb`, the
output included the following line

```
Bus 001 Device 007: ID 1050:0116 Yubico.com Yubikey NEO(-N) OTP+U2F+CCID
```

Notice the colon separated values, 1050 and 0116 match `idVendor` and
`idProduct` respectively. You'll have to use these values in your `config.scm`

## Reconfigure your system.

Now is you need to run

```
sudo guix system reconfigure ~/config.scm
```

and reboot.

After reboot, you can test if things worked by doing

```
$ cat /dev/hidraw0
```

If you don't get a "permission denied" error, all is well. You should
be able to open chromium, firefox, or icecat and two-factor
authentication should be able to be handled by your browser.

## Conclusion and caveats

That's it, that's all it took. For someone like me who's completely
new to the guix API, it took a while to figure this out. It didn't
help that I've also been shielded from having to write my own udev
rules this whole time. Now I've learned a little of both.

It should however be noted, since I am new at all of this, it's
certainly possible that there are problems with my code and
setup. There are certainly better, more elegant and more idiomatic
ways of getting this done, but at least I was able to push this post
to github now.