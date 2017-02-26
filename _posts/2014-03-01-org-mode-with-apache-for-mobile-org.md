---
title: org-mode with apache for mobile org
layout: post-03242013
published: true
---

## org-mode with apache for MobileOrg

When I started with [org-mode](http://orgmode.org/), I decided that I wanted to
incorporate [MobileOrg](http://mobileorg.ncogni.to/) into the setup so that I
could stay organized on the go.

Since I didn't want to do this with Dropbox, like in the MobileOrg instructions,
I decided to get my feet wet with WebDAV, which MobileOrg also supports. What
follows, is how I achieved this. All of these settings can be found in
my [emacs config](https://github.com/flooose/_emacs/) on github
in
[this file](https://github.com/flooose/_emacs/blob/master/_config/scripts-available/org-mode.el)

### The Setup

In order to get MobileOrg setup, you need a basic org-mode config. If you don't
have that, you can use the file linked above as a reference point. Something
like this somewhere in your emacs config should be enough for the purposes of
this post:

    (setq org-directory "~/Spaces/org-mode") ;; I use Team drive http://www.teamdrive.com/
    (setq org-default-notes-file (concat org-directory "/index.org"))

    (define-key global-map "\C-cc" 'org-capture)
    (setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/index.org") "Tasks")
        "* TODO %?\n  %i\n  %a")
       ("s" "Shopping" entry (file (concat org-directory "/shopping.org"))
      "* TODO %?\n  %i\n")))


Once that's in place, we need to tell org-mode about our mobile org setup:

    (setq org-mobile-directory "/scpc:chris@example.com:public_html/org/")
    (setq org-mobile-inbox-for-pull (concat org-directory "/from-mobile.org"))
    (setq org-mobile-files (list
                   (concat org-directory "/index.org")
                   (concat org-directory "/shopping.org")))
(setq org-mobile-keywords (list "shopping" "todo"))

The first line sets the directoy where org-mode will make files available for
MobileOrg. You can see that this is a remote folder where our WebDAV server will
be running. The second line tells org-mode that everything coming from the
remote folder should first be put in `from-mobile.org``. Once everything has
been downloaded from the remote folder, org-mode merges the contents of this
file into the rest of the org-mode infrastructure. To get a better idea of how
this works, [Pulling from
MobileOrg](http://orgmode.org/org.html#Pulling-from-MobileOrg.)

Setting up Apache webdav is a matter of enabling a module and then configuring
the directory from where you'll be serving the files. We'll be using
`public_html/org` as seen above.

    <Directory "/home/*/public_html">
        Dav On
        AuthType Basic
        AuthName "Not Public"
        AuthBasicProvider file
        # You can use the htdigest program to create the password database:
        #   htdigest -c "/usr/local/user.passwd" DAV-upload admin
        AuthUserFile /usr/local/etc/apache24/user.passwd
        # Allow universal read-access, but writes are restricted
        # to the admin user
        <RequireAny>
            Require valid-user
        </RequireAny>
        AllowOverride All
        Options All
        Require method GET POST PROPFIND OPTIONS
    </Directory>


After enabling the module in `/etc/httpd/conf/httpd.conf`, I thought I'd be able
to just add `Dav On` in my `Directory` directive, but it took some snooping
through the logs to see that the `Require method ...` needs to include
`PROPFIND`. After that, I had to run

    chown -R apache:chris ~/chris/public_html/org && chmod -R 664 ~/chris/public_html/org

because apache expects to own the files that it is serves. I hope to find a work
around for this at some point, but that can wait.

At this point we've got everything we need. Now we just have to set up MobileOrg
to use WebDAV, give him the user name and password
