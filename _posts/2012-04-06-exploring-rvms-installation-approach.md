---
title: Exploring RVM's bash invocation
layout: post-03242013
published: true
---
## Exploring the RVM Installation's _`bash`_ Call.

I've not done a lot of shell scripting, but I've done enough to know that it
interests me and that I'm not very proficient at it. Since my day-to-day work
doesn't take me beyond the basic scripts that I've written, I try to take
advantage of any opportunity to learn a little more about it.

That's what this post is going to be about.

If you've intalled Wayne Seguin's excellent [Ruby Version
Manager](https://rvm.io/rvm/install/) (RVM) recently, there's a pretty
good chance that you executed the following

<pre> $ bash < <(curl -s https://rvm.beginrescueend.com/install/rvm) </pre>

Well, the `bash` part of it is pretty straight forward for me, and so is the
`<`. The `curl -s https://rvm.beginrescueend.com/install/rvm` is also obviously
a command being executed. What's no so clear though, is why it's executed from
within `<()`. Let's dig in!

### Exploring the Documentation

You don't have to read far into the `bash`
"man-page":http://www.linuxmanpages.com/man1/bash.1.php before you stumble upon
the section `Compound Commands`

Among the things mentioned in this section is the following:

    (list) list is executed in a subshell environment (see COMMAND EXECUTION
    ENVIRONMENT below). Variable assignments and builtin commands that affect
    the shell's environment do not remain in effect after the command completes.
    The return status is the exit status of list.

playing the "recursive dictionary" game, we need to look up what a "list" is.
Good thing that was mentioned just above in the appropriatly named section
'Lists':

    A list is a sequence of one or more pipelines separated by one of the
    operators ;, &, &&, or ||, and optionally terminated by one of ;, &, or
    <newline>.

Okay, we could go on playing the game and look up "pipeline", but for
simplicity, we'll just spill the beans and mention that a "pipeline" is exactly
what we expect:

<pre>
$ cat some_huge.file | grep 'ordinary_word'
</pre>

There are other pipelines, but I think everyone is familiar with this pattern.

### Trying Some Stuff Out

So let's move on. We now know that our command `curl` is being executed in a
subshell.

My understanding of the `<` directly in front of the subshell command now seems
a bit limited. I've generally used the `<` operator in situations similar to the
following:

    $ mysql -u username database_name < sql_dump.sql

where `sql_dump.sql` is always a file name. If I take this example and think of
`< sql_dump.sql` to mean, "feed a bunch of text to the `mysql` command", then
the `<(curl -s https://rvm.beginrescueend.com/install/rvm)` could also be seen
as feeding a bunch of text to something, but for that, there is already an input
redirection there, followed by this strange `<(...)` list construction, so it's
not simply about redirection.

I did a little exercise:

<pre>
$ cat ~/rvm_fun
echo '##### LISTING DIRECTORY CONTENTS #####'
ls
$ bash rvm_fun
##### LISTING DIRECTORY CONTENTS #####
Desktop		Downloads	Library		Movies		Pictures	Public		VirtualBox VMs	hardcopy.0	pgadmin.log	trash
Documents	Dropbox		Mail		Music		Projects	Sites		alpm_ruby	nina		rvm_fun
$ bash <(cat rvm_fun)
##### LISTING DIRECTORY CONTENTS #####
Desktop		Downloads	Library		Movies		Pictures	Public		VirtualBox VMs	hardcopy.0	pgadmin.log	trash
Documents	Dropbox		Mail		Music		Projects	Sites		alpm_ruby	nina		rvm_fun
$ bash < <(cat rvm_fun)
##### LISTING DIRECTORY CONTENTS #####
Desktop		Downloads	Library		Movies		Pictures	Public		VirtualBox VMs	hardcopy.0	pgadmin.log	trash
Documents	Dropbox		Mail		Music		Projects	Sites		alpm_ruby	nina		rvm_fun
</pre>

So, I saved some commands in `rvm_fun` and used two different forms of file
redirection. First I did it the way that looked more familiar to me, i.e. like
the sql_dump example above. Surprisingly, it worked. Next I tried it their way,
which yielded the same result.

### An _Aha!_ Moment

I suspected that all of this was covered in the `REDIRECTION` section of the man
page. I had spent some time reading it and decided that I just didn't get it
all, so I experimented with the different versions of the command. There was one
more thing I could do to make my version of the RVM command, `bash <(cat
rvm_fun)` look more like my version of the sql command, `mysql -u username
database_name < sql_dump.sql`. What happens if my version of the RVM command has
a space after `<`, like in the sql command:

```
$ bash < (cat rvm_fun)
-bash: syntax error near unexpected token `('
```

Aha! So this isn't just a simple `bash` list, being modified by a `<` operator.

The first order of business was getting an understanding for file descriptors.
Here again, I felt that I had an intuition about what they were, but based on
the issues I was running into above, I realized that I needed a more concrete
understanding for what they actually are. For this, I had to cheat a little and
turn a way from the `bash` man page. I turned my attention the
[_"Advanced Bash-Scripting Guide"_](http://tldp.org/LDP/abs/html/), an
excellent, example driven book that is freely available on the internet.

Chapter 19 of `Advanced Bash-Scripting Guide` concretely states:

    A file descriptor is simply a number that the operating system assigns to an
    open file to keep track of it. Consider it a simplified type of file
    pointer. It is analogous to a file handle in C.

Great. This is in sync with my intuition about what a file descriptor is. Within
the same chapter, I was also reminded that that `stdin`, `stdout`, and `stderr`
also have file descriptors. This seems like it could be important later on.

Chapter 19 was quite interesting, but I didn't find my solution. I got a little
further when I stumbled over Chapter 22 `Process Substitution`. There it was in
black and white: the `<(some_command)` construct is actually a central part of
`bash`, a language construct not a composite of a list and some other operator.
It goes on to point out some things specific to this post. First, `bash
<(rvm_fun)` is the same as `cat rvm_fun | bash`, which I verified and it worked.
So why `bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)` instead of
simply `bash <(curl -s https://rvm.beginrescueend.com/install/rvm)`?

Chapter 22 goes further. It gives other examples of "Process Subsitution". One
specific example stands out:

<pre>
read -a list < <( od -Ad -w24 -t u2 /dev/urandom )
# Read a list of random numbers from /dev/urandom,
# process with "od"
# and feed into stdin of "read" . . .
</pre>

### First Conclusions

So my current understanding is that the

<pre>
`bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)`
</pre>

feeds the output of the curl command into the `stdin` of `bash`, i.e. it
redirects it to the `stdin` of the `bash` command, while the

<pre>
`bash <(curl -s https://rvm.beginrescueend.com/install/rvm)`
</pre>

presents it as a command line argument to the `bash` command.

There is still something a little unsettling about this though. I did a little
more research and decided that finding the difference between `<(...)` and
`$(...)` (or ``...``, as some people know it) must give the ultimate insight
into all of this.

It turns out that this is the difference between Process Substitution and
Command Substitution, the latter of which is covered in Chapter 11 of the
Advanced Bash-Scripting Guide:http://tldp.org/LDP/abs/html/.

Now that we know the difference by name, figuring out the difference in practice
is almost trivial and can be summed up as follows:

Command substitution works by executing some command in a subshell and placing
the output on the command line of some other command. Process substitution works
by executing some command in a subshell and placing the output in a file
descriptor, i.e. a file, from which it's output is read.

Instead of putting the output directly on the command line, the output is put in
a file, which is then given to the command line. The simplest use case for this
is for commands that expect files. Here's an example: `diff` can't compare two
strings

<pre>
$ diff "abc123" "cdf456"
diff: abc123: No such file or directory
diff: cdf456: No such file or directory
</pre>

or even

<pre>
$ diff $(echo "abc123") $(echo "cdf456")
diff: abc123: No such file or directory
diff: cdf456: No such file or directory
</pre>

but if we do:

<pre>
$ diff <(echo "abc123") <(echo "cdf456")
1c1
< abc123
---
> cdf456
</pre>

it works. Diff needs files from which to read.

### Conclusion

So now my previously stated current understanding must be refined from
"...presents it as a command line argument..." to "...presents it as a command
line argument in the form of a file..."

Now, we've almost completed the exercise. We just need to answer the question,
why to use `bash < <(...)curl` as opposed to something else.

With our new found knowledge of the `<(...)` construct we can use it in place of
anywhere where we might stick a file.

In the case of `bash`, since it can be invoked with input piped to it with `|`,
redirected with `<` or simply given a file name, we should be able to do the
following, respectively:

<pre>
$ cat <(curl...) | bash
</pre>

<pre>
$ bash < <(curl...)
</pre>

<pre>
$ bash <(curl...)
</pre>

and each time, the result should be a successful install of RVM. It turns out
that that's exactly true. The final two examples are really worth touching on
though. The first of these two is of course the very command that inspired this
article, but notice that the second of these two doesn't have the contents of
`<(curl...)` fed to `bash` via the `<` input redirector. This is because `bash`,
unlike `diff` can be fed a file directly.

So as far as I can tell, the question of why one would choose one form over
another, seems really to be one of a matter of taste.

That's it. A long article, but it certainly cleared a lot of things up. I
actually feel pretty confident about any `bash` scripting I might undertake in
the future. Perhaps a follow-up article about data manipulation is in order now.
