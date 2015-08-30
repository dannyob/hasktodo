[![Build Status](https://travis-ci.org/dannyob/hasktodo.svg?branch=master)](https://travis-ci.org/dannyob/hasktodo)

# HaskTodo

I've been using a homegrown todo.txt handler since 2010 to give me a rough
guide to what to do next in my life. The workflow is pretty simple: I edit a
list of tasks stored in a todo.txt file, using Vim in
[vim-outliner](https://github.com/vimoutliner/vimoutliner) mode with some
convienient additional keyboard shortcuts.

Each task takes up one line of English text, with additional tags added using
single, capitalized words beginning with either an @ or a # symbol.

    go buy fireworks @SHOPS @WEEKDAY @MORNING #BONFIRENIGHT

The @ tags are used to indicate context: I want to do this in the morning on a
weekday, when I'm shopping. The # signifies a project. A project might have
more than one todo.

When I want to know what to do next in my life, I run a command line program
called `tnext`. Without any extra arguments, `tnext` looks over my `todo.txt`
file, and makes a calculated guess at what I should be doing at this moment in
time. Its output looks a little like this:

    % tnext
    Changing tags from  ['#BONFIRENIGHT', '@WEEKEND', '@URGENT', '@UKTIME', '@SUNDAY', '@DAILY']  to  ['#BONFIRENIGHT', '@WEEKDAY', '@URGENT', '@UKTIME', '@MONDAY', '@DAILY']
    2015-08-31T09:40-0800 go buy fireworks @SHOPS @WEEKDAY @MORNING #BONFIRENIGHT

As you can see, `tnext` has decided that what I should do right now is go out
and buy some fireworks. At heart, it does this by creating a list of tags that
apply to the current moment, and then looking through its collection of tasks
until it finds the one with the most tags in common.

There's lots more to my current todo.txt handling program, which is written in
a combination of Python and VimL. If you're looking for something that actually
works (roughly), take a look at [its repository](https://github.com/dannyob/lifehacking). 

The code you find here is my attempt to update and improve my working code. By
way of experiment and for purposes of auto-pedagological masochism, I'm
choosing to re-implement my old handler in Haskell.

If this folder is almost empty apart from a set of TODOs, then you shouldn't be
at all surprised. If it isn't, maybe this productivity aid actually works after
all.
