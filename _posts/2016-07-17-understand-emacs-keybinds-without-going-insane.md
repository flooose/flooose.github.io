---
title: understand emacs keybindings without going insane
layout: post-03242013
published: true
---

## Introduction

Keybindings in emacs is anything but straight-forward. It's not something that's
impossible to understand, but it takes time, and for people who want to have
enough understanding of the subject to give their choice of custom user key
bindings some sense of organization and mnemonics, here's my distilled version
of what's most necessary from the
[17 sections](https://www.gnu.org/software/emacs/manual/html_node/elisp/Keymaps.html)
of the "Keymaps" section of the
[Emacs Lisp reference manual](https://www.gnu.org/software/emacs/manual/html_node/elisp/).



### The Problem

Emacs lets you set key bindings pretty easily with, say, `global-set-key`. The
problem with this is that with the countless major and minor modes out there,
it's not only difficult to pick set your bindings so that they don't conflict
with key bindings provided by another mode, but also nearly impossible to pick
one that won't at some future time in some future mode have conflicts with that
modes key bindings. 

Emacs'
[answer](https://www.gnu.org/software/emacs/manual/html_node/elisp/Key-Binding-Conventions.html)
to this is to have the convention that `C-c **some letter**`, e.g. `C-c a` be
reserved for user defined key bindings, i.e. publishers of major and minor modes
are advised not to bind their commands to these combinations. What's important
to notice here is that while the above convention of `C-c **some letter**` is
reserved for user defined key bindings, the combination `C-c C-**some other
letter** **some letter**`, i.e. `C-c C-a a`, is **NOT** reserved for users and
is free for developers of emacs modes to use.

This leaves (depending on the language of your keyboard) about 26 key
combinations (52 if you want to count the uppercase equivalents) for the user to
have at their disposal, which does not leave much room in the way of mnemonics
or some other for of organization of key bindings.

### The Solution 

The solution to this problem is binding keymaps to these keys, not functions. At
it's most basic, a keymap is a set of active key bindings. If you're editing,
for instance a markdown source file, chances are that you've got `markdown-mode`
active as your major mode and that it comes with a keymap named
`markdown-mode-map`. 

The thing to know though is that other keymaps can be made
temporarily active, meaning that if you activate `my-special-keymap`, then
pressing the letter "a", or something like that, won't have the same effect as
when the keymap hasn't been activated, where pressing "a" most likely has the
effect of printing the letter "a" into your buffer.

So a fundamental part of every emacs config should be a collection of user
defined keymaps. It's simple

```
(setq my-navigation-keymap (make-sparse-keymap))
(define-key my-navigation-keymap "a" 'back-to-indentation)
```

Here I use `make-sparse-keymap` to define a keymap. In the beginning you'll
probably always want to use sparse-keymaps. After I defined the keymap, I used
`define-key` to define a key binding in the map.

Now all we have to do is activate the keymap in some way. We do this by using
`global-set-key`:

```
(global-set-key (kbd "C-c n") my-navigation-keymap)
```

Now when I do `C-c n`, I activate a `my-navigation-keymap` and by pressing `a`
while this keymap is active, I call `back-to-indentation`. 

### Conclusion

This allows for a
well organized, understandable keybinding scheme. For example, I use `C-c e` for
my custom _editing_ keymap and `C-c r` for my custom _region_ keymap.

I avoid binding anything to "top level" `C-c **some letter** combinations and
try to only bind keymaps to these keys.

