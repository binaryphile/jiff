## Jiff

[Jiff] is sort of an automation notebook.  Jiff helps you turn your
command-line system configuration rituals into simple tasks, available
wherever you need them.

## Support

Jiff currently has explicit support for Ubuntu 14, 15, CentOS 6 and Red
Hat 6, although it will work on any standard unix which supports
symlinks.

## Motivation

I build and rebuild a lot of unix machines.  I also deal with multiple
unix platforms, primarily Red Hat/CentOS and Ubuntu/Debian.

In the past I've used tools like plain old shell scripts, [git], [Rake],
[Ansible], [Puppet], [Chef] or [SaltStack], even
[fucking_shell_scripts] to handle system configuration tasks.

The biggest problem with most of these is that they don't do enough of
what I want (shell scripts, git, Rake), or they do way too much
(everything else).

Most of these tools force you to learn their library of functionality
first, then to adapt your methods to them.  Ain't nobody got time for
that.

Instead I want a system that makes it easy for me to capture what I've
already accomplished and make it easier next time.  I need a tool which
matches my workflow.

My workflow is probably fairly typical.  I have some piece of software I
need, usually installable through the system package manager, then I go
out and find a blog post on how to configure it. Afterwards I make a few
adaptations of my own.  By the time I'm done, all I have to show for the
process is my shell history.

I want a tool which is forensically focused, which helps me examine what
I've done after I've done it then codify that.  Jiff is that tool.

## What It Is

Jiff is a toolkit first and foremost.  It is meant to be personal and
customized to the user, so it must be built by the user.  While it could
be thought of as a DWIM (Do What I Mean) system, it's actually a DWYM
(Do What YOU Mean) system...only you can tell it how to do what you
want.

In the absence of even a single specific task for it, I still know
a few things it needs to provide:

- easy deployment - whatever I create, make it available everywhere I
  need it with a single command (or as few as possible)
- modular, extensible - new bits should be added in self-contained
  chunks but presented under a single umbrella
- true to the cli - as close as possible to how I do things when I'm not
  using it
- multi-environment: it has to make administering one environment as
  close as possible to another

While Jiff is a bit more complex than I'd like, mostly due to managing
multiple environments, it's the happiest I've been with my attempts thus
far.

## Installation

User-land install (no sudo necessary):

    curl -sL https://raw.githubusercontent.com/binaryphile/jiff/master/install-jiff | bash

NOTE: you will be prompted to clone this repository to your github
account!  The script will do this for you, but you will be running your
own copy of the jiff repo.

Along with your new jiff repo, this will install [basher] in the user's
home directory, as well as add both jiff and basher to the path.

Currently only bash installation is supported, but basher has
instructions for adding it to zsh and fish.  Once basher is installed,
jiff is available automatically.

## Tasks

Jiff comes with just the functionality necessary to manage itself.
You're expected to provide scripts for what you want it to automate.

Jiff's bread and butter are called tasks, which are simply scripts (or
even programs) you create with a special name.  Each script is then
accessible as a subcommand to jiff, e.g.:

    jiff my_new_task

Jiff will invoke the new task you have created and pass it your
arguments as if you had run the script directly yourself.

While this is fine, it doesn't buy you much more than some extra typing
when compared to just writing your own scripts in a directory on your
path.

## Contexts

What makes this a little more useful are contexts.  At its most basic, a
context is just a directory with some extra scripts which happen to
apply to the environment in which you are currently working.

For example, if you've written a system configuration script that works
on your Red Hat system at work, it probably won't work on your home
Ubuntu system.  Not that you'd necessarily want it to.

Because that script is context sensitive, it doesn't necessarily make
sense to have it available when working in another context.  Jiff's
contexts allow you to name where a script is useful and only have it
available in that environment.

## Overlapping Tasks

While that's only a bit useful, where it becomes more useful is when you
have a task that you do need to accomplish across a variety of
environments.  Ones which require different implementations depending on
where they are run.

You could just write a single script which attempts to do the right
thing in every environment.  I find this approach cumbersome because
while the task is the same, the steps are frequently non-overlapping
between environments.  The flow of the script becomes tangled with
conditionals and other obfuscating details.  It just gets messy.

An example is installing git, which I like to maintain at a par version
on all systems.  More than one distro can use the built-in package
manager, which is great.  They still require different commands to
install however.

Others require compilation from source, which dictates a set of
prerequisite packages be installed.  These too vary by distro.  All told
I may have three or four processes for installing git across the board.

Contexts separate these nicely.  I can have a task of the same name for
each environment, each with a completely different implementation.

Either at the command line, or via a script, I can specify the context
and then "jiff install git", and the right thing will always happen
(presuming I've written the install script for that environment).

I've also worked it so I don't have to actually write a separate script
if the environment has the right version in the package manager, but
that's another matter.

## Roles

As if a sysadmin's life weren't hard enough, you also need to worry
about what role you are playing when you're configuring your
environment.  Is it just for me, the user, or is it for the entire
system as an administrator?

Jiff assumes you are performing your duties as an administrator, but
allows you to define user-scoped tasks as well.

For example, on some systems I am a guest user and do not have sudo
access.  In these cases, I can still install some software within my
user directory under "~/.local" and use it from there.

Again, rather than employing command-line switches and logic in my
install scripts, I prefer to make distinct, simpler scripts available
for either situation.

Jiff's "jiff role" command allows you to specify a different role.  That
makes your new tasks available and/or overrides the administrative
versions of your old tasks.  (which ones depend on what you choose to
write)

For example, I can have a git installation script which installs the
system git via the package manager as an administrator, and another
which downloads and unpacks a known-good statically-compiled version
into my home directory as a user.

By switching roles first, I can run the same command "jiff install git"
and get the desired behavior.

You can even create other roles, although I don't see that being
a big feature for most people.

## Creating Contexts

By default, jiff runs out of a default context as an administrative
role.

What that means is that the only tasks available are:

- jiff's commands to manage jiff
- some basic, non-distro-specific tasks
- anything you create in the default context, which probably doesn't
  belong there

What you should really do before creating any new tasks is to create a
context that describes where you're working.

Jiff's directory (I encourage you to look at it, it's at
`~/.basher/cellar/packages/your-github/jiff`) includes an empty folder
called "context".  This is where your scripts will mostly go.

To start with, you might use the physical location of the machine that
you are going to begin with, such as "office".  The name isn't very
important other than providing you something memorable to work with.

    jiff context add office

Now your context will be set to "office".  If you look at the directory
again, you should see a much different structure.  There will be a
"current" symlink which points to something like (assume you're on
Ubuntu Wily):

    [jiff root]/context/office/ubuntu-15/role

"role" is a link which points to the "admin" directory in the ubuntu-15
folder.  That's because the admin role is the default.  Switching roles
switches that link to point to the "user" folder instead.

Your distro will be auto-detected (hopefully) and the appropriate
subfolder created for your environment.

Now if you add a task, it will appear in:

    [jiff root]/context/office/ubuntu-15/admin

So long as "office" is your context (and you are on an ubuntu-15
machine), tasks in that folder will be automatically available to jiff.

### See what contexts are available and/or enabled

    jiff context

### Add a new context

This will automatically enable the new context:

    jiff context add office

### Enable a context

If you already have one you want:

    jiff context enable office

### List available tasks

    jiff tasks

### Get help on specific tasks

    jiff help [task name]

### Install a system package

    jiff install [package name]

"jiff install" is a platform-specific task, so it requires that you have
enabled a platform with "jiff use" prior to use.

"jiff install" simply wraps the package manager for your platform,
allowing you to write configuration scripts without having to worry
about the vagaries of apt and yum syntax.

### Install a package customized with a specific task implementation

    jiff install-[your task name which matches the package name]

or

    jiff install [package name]

"jiff install" will first see whether there is a specific jiff task of
the same name as the package for the current platform, prefixed with
"install-".  If so, it will run that task instead.  This allows you to
customize or override your installations specifically on the platforms
which require it.

For example, you can install a package via the normal package manager on
one platform while on another, you use a custom script to install from
source.  Because the custom task is only enabled on the platform which
needs it, "jiff install" picks up on that fact and uses the appropriate
method, without having to use your command-line syntax to tell the
difference.

## Why So Many Knobs and Buttons?

I wanted something that just made details go away in favor of simple
commands.  Unfortunately, reality is less forgiving.

Contexts are real things.  They represent course-changing restrictions,
such as:

- assumptions as to what resources may be available to you at the time (e.g. because of
firewalls/proxies)
- organizational practices you may be required to observe
- anything which causes you to code differently than elsewhere

and so on.

Add onto that the realities of differing roles, sometimes within the
same environment, as well as the all-to-concrete differences in os
distributions.  It can be maddening.

All of these inconvenient realities end up forcing you to write many
different procedures for the same task.  Homegrown one-size-fits-all
scripting becomes impossible.

Nevertheless I like homegrown scripting.  Even I don't know how I want
something set up before I do it myself.  How can any tool anticipate
that for me, or worse, attempt to dictate a process for it?

Jiff tries to intelligently hide unecessary detail where possible, while
still providing the ability to cope with any combination of these
restrictions and still write simple, beautiful scripts.

### Create a new generic jiff task

    jiff task add [task name]

### Push your task to your jiff repo

    jiff task publish [task name]

### Update jiff and its dependencies to the latest version (e.g. to get your new task elsewhere)

    jiff jiff-update

Note: this is currently hardcoded to my personal jiff repo so it won't
work for you yet.

### Create a new platform-specific jiff task (for the current platform)

    jiff task add --platform [task name]

Note: not yet implemented

### Create a new platform-specific jiff task (for another platform)

    jiff task add --platform=[platform name] [task name]

Note: not yet implemented

### Add a new platform

   jiff platform add [platform name]

Note: not yet implemented

If you want the "jiff use auto" task to work with your new platform, you
will need to clone my bash-libs repo and implement your own detection in
"../bash-libs/lib/stdlib".

Otherwise you can still tell jiff to use the platform by specifying it
directly instead of "auto".

## Bash

Good old Bash.  Why?  Because even though I don't use bash as my
personal shell, there's a million lines of it out there waiting to be
copied and pasted.  If you encounter a system administration conundrum
soluble by the cli, bash can do it, and someone's already written the
solution.

But you don't have to use bash to run your tasks, that's just what I
use.  Jiff tasks can be any executable whatsoever, thanks to [sub].

## Sub

Jiff tasks should check to see whether their particular job has already
been done and exit gracefully (return 0) if so.  That allows any jiff
task can run another jiff task as a prerequisite and not have to worry
that the prereq will have problems if, for example, it has been called
twice because two parts of the task have the same prereq.

Prior to using any platform-specific jiff tasks, you'll want to run
"jiff use auto" to set up the links for your distro (ubuntu, centos,
etc.)

[jiff]: https://github.com/binaryphile/jiff
[git]: https://git-scm.com/
[rake]: http://docs.seattlerb.org/rake/
[ansible]: http://www.ansible.com/
[puppet]: https://puppetlabs.com/
[chef]: https://www.chef.io/
[saltstack]: https://saltstack.com/
[fucking_shell_scripts]: https://github.com/brandonhilkert/fucking_shell_scripts
[basher]: https://github.com/basherpm/basher
[sub]: https://github.com/basecamp/sub
