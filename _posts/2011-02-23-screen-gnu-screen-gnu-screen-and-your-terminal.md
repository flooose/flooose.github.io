---
title: Hands off! An attempt at a mouseless work-flow with Gnu Screen
layout: post-03242013
published: true
---
## Hands off! An attempt at a mouseless work-flow with Gnu Screen

### What's screen? Why this post?

Screen is a program that brings the idea of windows to the console/terminal. The
man page states that "Screen is a full-screen window manager...", but for the
purposes of this experiment, it's enough to know that it has the concept of
windows and that once started, gnu screen can be disconnected from and
reconnnected to at will, with previously running programs left uninterrupted.

Perhaps the most immediate motivation for using screen, is that it can be
started remotely, where the above-mentioned feature can be taken advantage of to
allow you to start long running programs without the risk of having them killed,
or having to kill them, when the network connection is closed.

Here's an example of one of my typical screen sessions that takes advantage of
this functionality:

<pre>
[my_computer] $ ssh someserver.com
[their_puter] $ screen
[their_puter] $ rake import:really_huge_db_dump
starting import of 1.5 GB sql dump
 ^A ^D
[detached]
[their_puter] $ exit
Connection to someserver.com closed
[my_computer] $
</pre>

...time passes...

<pre>
p(code). [my_computer] $ ssh someserver.com
[their_puter] $ screen -r
[their_puter] $ rake import:really:huge:db_dump
starting import of 1.5 GB sql dump
finished import of 1.5 GB sql dump. Took 15 hours.
[their_puter] $
</pre>

The motivation for this experiment simply came after discovering screen and its
ability to do the above, and wondering if I could eliminate reaching for the
mouse while I'm programming. I don't use the mouse much to begin with and I find
that it interrupts my work flow when I do have to reach for it.

### Next steps, going beyond the basics.

The sample session above is dead simple. I learned it the first day and although
it solved a concrete problem for me. It didn't get me far beyond wondering *if*
it could be used in terms of this experiment. So what's the next step?

Well what I mainly do in the terminal is run programs and watch output (e.g. log
files, rails servers, rails console, etc.). In a typical windowing environment,
my editor is usually in one window and I switch to my terminal with `alt + tab`,
so if I'm running my editor in a screen session, how do I "`alt + tab`" to my
log output?

### Windows

This is where screen's ability to manage windows comes in. In screen you can get
another window by pressing `^a ^c`. In fact, all commands for controlling screen
are initiated with `^a`. So `^a ^c` creates new windows and cycling through them
is done with `^a ^n` and `^a ^p`.

On the one hand this does solve the problem of doing two things within one
screen session, but most terminal programs have tabbing capabilities and ways of
cycing through those tabs without using the mouse. So does screen offer anything
to sweeten the deal?

Well for starters, a screen window can be split, i.e. two windows are displayed
at the same time, meaning that you can input commands on one side and, for
instance, tail that log on the other side. I'll get into split-screen screen
more at the end of this post because there are some caveats to consider that
were easier to deal with once I had some experience with screen.

Again, other terminal emulators offer split-screen too, but it's less common and
it's nice to see that screen offers it too, so screen survives and the
experiment goes on.

|Description|Command|
|-----------|---------|
|New window   | `^a ^c`   |
|Previous window| `^a ^p` |
|Next window|`^a ^n` |

### Disconnecting from screen

Once I could do the above, I had everything necessary to do some real work. Now,
how do we not interrupt that when it's time to go home after work? `^a ^d` gets
that done. After issuing this command, it's safe to completely close your
terminal or sever the ssh session. When you're ready to reconnect, you simply
log into your server and issue the command `screen -r`. If you've got multiple
screen sessions running (also a possibility), this command will fail and show
you a list of running sessions similar to:

<pre>
[my_computer] $ screen -r
There are several suitable screens on:
      29594.ttys007.my_computer	(Multi, detached)
      57888.ttys002.my_computer	(Multi, detached)
Type "screen [-d] -r [pid.]tty.host" to resume one of them.
</pre>

You get some instructions about reconnecting to one of them, but I've discovered
that the number directly before the "tty..." part of each item in the list is
the PID of the process and simply issuing the command `screen -r 29594` will get
you reconnected to that session. So in summary:

|Description|Command|
|-----------|---------|
|Disconnect from current session  | `^a ^d`   |
|Connect to running session | `screen -r [PID]` |

### Some configuration

I discovered something else. Screen is pretty configurable. For instance, you
don't really get an overview of your windows as you create them in screen. This
was a little disorienting while I was learning screen and started working with
more than just one window.

Luckily I found this config:

<pre>
$ cat ~/.screenrc
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{=kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B}%Y-%m-%d %{W}%c %{g}]'
$
</pre>

I can't remember where I found it, but a simple
[search](http://www.google.com/search?hl=en&q=gnu+screen+status+bar&aq=f&oq)
yielded results well worth exploring.

This will get you something like this at the bottom of each one of your screen
windows

<div id="status-bar">
<pre> [ (none) ][       0$ bash  1$ bash  2-$ bash  (3*$bash)         ][2011-03-07 18:16 ] </pre>
</div>

It's easy to see that this is more or less the equivalent of a console based
windows panel. In the middle you see that there are four `bash` windows and that
`(3*$bash)` is the active one. You even get a clock on the right.

|Description|Command|
| Goto window <number>  | `^a <number>`   |

### Working with the console output

I mentioned above that I mainly run programs and tail log files in the terminal.
At this point I know how to do both at the same time in one screen session by
taking advantage of its windowing functionality, but I quickly realized that
this comes at a cost: scrolling with the mouse ceases to work (I've since
discovered that this isn't true for all terminal programs).

This is probably the one thing that I did enjoy doing with the mouse. Scrolling
up and down through the terminal with the flip of a finger is a great way to
look through terminal output, especially if you're looking for a specific
pattern (i.e. error messages), so I guess it never really felt like something
that affected my work flow. Now that I was without it, it felt like something
was missing.

### Copy-mode to the rescue

I discovered that "scrolling" is accomplished in screen by entering "copy-mode".

By pressing `^a ^[` you enter 'copy-mode' in screen, which allows you to navigate the screen content as if it were a vim or emacs buffer, in fact, you even navigate the buffer with vim key bindings (i.e. h,j,k,l). At first this felt like a somewhat sluggish and unsatisfactory way of reviewing command output, but I soon discovered that it actually offered some real advantages and that it pays off once you overcome the inertia of trying to scroll with the mouse. I'll explain that in just a bit.

So, as I said, `^a ^[` got me into copy mode and once you're there, you navigate the buffer with vim key bindings. h,j,k and l move you left, down, up and right one unit respectively and `c-u` and `c-d` page up and page down respectively. That's really all the scrolling I need. `esc` got me out of copy-mode and back to the prompt, ready to type commands normally.

|Description|Command|
|-----------|---------|
| enter copy-mode  | `^a [`   |
| left, up, down, right  |`h,j,k,l`    |
| page-up  | `^u`   |
| page-down  | `^d`   |

### Extra benefits of copy-mode

I mentioned that spending some time with copy-mode, would pay off once you overcome the inertia of wanting to scroll with the mouse. Well, the pay off is that in screen, copy-mode is not just limited to navigating, it's also great for (you guessed it) copying.

After navigating to various parts of the buffer as highlighted above, the `space` bar activates highlighting. You then navigate to another part of the buffer, press `space` again, and you've got everything in the highlighted region copied. Now pressing `^a^]` in any program in any window within your screen session (mutt, ttytter, emacs, vim, etc.) pastes the content.

I really found this to be a great feature. Whatever small discomforts there might have been when I first started working with output like this were really surpassed by this feature.

|Description|Command|
|-----------|---------|
| mark beginning of region  | `space` |
| copy highlighted region  | `space`  |
| paste  | `^]` |

### Extras

One final thing I tried was the concept of split screen screen sessions. For the sake of clarity, I'm going to refer to different parts of a split-screen screen as regions. Meaning that if you split a window in screen, you will have 2 regions. This is consistent with the screen documentation, so further reading shouldn't be too confusing after this.

I mentioned above that there were some caveats to take into consideration, so before talking about my experiences with split-screen screen, let me outline them here:

<div id="caveats-list">
*(caveats) The current version of screen only allows you to split the screen horizontally, meaning you get one window above the other. This, at least for me, is a less than preferred way of working with a split screen. There is a patched version (and I believe it's been merged into the development of screen) that allows you to split the window vertically. This was the only way I found split-screen screen to be worthwhile
* The way that split-screen screen works makes the above config with the windows panel sort of unintuitive. Once the screen has been split, you can't got from one window with a split screen to another window without a split screen, instead, all windows are split now and you can only switch windows within the split regions. I realize that sounds confusing, but I can't explain it better, so just try it (and compare it with the way split-screen works in iterm, which is the way I would have expected it to work). Writing this now, it actually doesn't seem so unintuitive any more, but I'm afraid it might only be because I've worked with it while writing this article, hence, I mention it.
</div>

So, with the caveats out of the way, here's my summary of my experience with split-screen screen, which, in spite of the caveats, were pretty positive.

Splitting the screen can be accomplished `^a ^s` with (horizontal split) and `^|` for vertical splits (in the patched version). After my first attempt at a vertical split, I realized that simply splitting didn't do much beyond just that. In order to get anything meaningful out of it, I had to switch to the window with `^a tab` and do the usual `^a 1` or 2 or 3 depending on which window I want displayed in that region. After that, I was good to go, `^a tab` followed by, for instance, `tail -f some.log` allowed me to watch some log file, while `^a tab` again allowed me to switch back to a different window to, for instance, restart some service that wouldn't start.

That's really all that's too it. Here once more are the relevant commands:

|Description|Command|
|-----------|---------|
| split screen horizonatally  | `^a ^s` |
| split screen vertically  | `^a` <span style="font-family: monospace; font-size: 0.82em;">&#124;</span> |
| switch section | `^a tab` |

### Literal ctrl-a

One of the consequences of using `^a ^something` as a way to issue commands to screen is that `^a` is no longer available to your other programs, i.e. bash and (god forbid you use) emacs (like me). So the question is, how do you issue a literal `^a` to be passed through to the program running inside of screen? `^a a`, that simple :)

p(section-title). Summary and Documentation

So that's it. I've been using gnu screen for some time and with the exception of some minor things, what I've covered above is all that it takes to have a satisfying experience in gnu screen. It really doesn't feel like there is anything missing by foregoing graphical, clickable functionality. There are other great features too and I might cover them in a follow-up post.

Like all gnu projects, screen is very well documented, and here's a "link":http://www.gnu.org/software/screen/manual/screen.pdf to an (actually) rather short and easy-to-read copy of the gnu-screen manual. I suggest you check it out. It really was easy to get through and it quickly turned into a reference more than a monolith of recondite information, like so many other powerful tools do.
