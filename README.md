## Jiff

[Jiff] is sort of an automation notebook.  Jiff helps you turn your
command-line system configuration rituals into simple commands,
available wherever you need them.

## Motivation

I build and rebuild a lot of unix machines.  I also deal with multiple
unix platforms, primarily Red Hat/CentOS and Ubuntu/Debian.

In the past I've used tools like plain old shell scripts, [git], [Rake],
[Ansible], [Puppet], [Chef] or [SaltStack], even
[fucking_shell_scripts].

The biggest problem with most of these is that they don't do enough of
what I want (shell scripts, git, Rake), or they do way too much
(everything else).

Most of these tools force you to learn their library of functionality
and then adapt your methods to them.  Ain't nobody got time for that.

Instead I wanted a system that makes it easy for me to capture what I've
already accomplished and make it easier next time.  I need a tool which
matches my workflow.

I typically have some piece of software I need, then I go out and find a
blog post on how to configure it and make a few adaptations of my own.
By the time I'm done, all I have to show for the process is my shell
history.

I wanted a tool which is forensically focused, which helps me examine
what I've done after I've done it then codify that.  Jiff is that tool.

## What It Is

Jiff is a toolkit first and foremost.  It is meant to be personal and
customized to the user, so it must be built by the user.  While it could
be thought of as a DWIM (Do What I Mean) system, it's actually a DWYM
(Do What YOU Mean) system...only you can tell it how to do what you
want.

In the absence of even a single specific task for it, I still knew
a few things it would need to provide:

- easy deployment - whatever I create, make it instantly available
  everywhere I need it
- modular, extensible - new bits should be added in self-contained
  chunks but presented under a single umbrella
- true to the cli - as close as possible to how I do things when I'm not
  using it

Jiff is the happiest I've been with my attempts thus far.

## Installation

    curl -sL https://raw.githubusercontent.com/binaryphile/jiff/master/install-jiff.sh | bash

NOTE: you will be prompted to clone this repository to your github
account!  The script will do this for you, but you will be running your
own copy of jiff.

Along with your new jiff repo, this will install [basher] in the user's
home directory and add them both to the path.

Currently only bash installation is supported, but basher has
instructions for adding it to zsh and fish.  Once basher is installed,
jiff is available automatically.

See the "libexec/jiff-basher" script for system-wide installation (and
read it before running it).

## Usage

Jiff comes with some built-in functionality, although mostly you are
expected to implement your own.  Here are some examples:

### See what platforms are available and/or enabled

    jiff use

### Enable platform-specific tasks

    jiff use auto

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

    jiff [your task name which matches the package name]

or

    jiff install [package name]

"jiff install" will first see whether there is a specific jiff task of
the same name as the package for the current platform.  If so, it will
run that task instead.  This allows you to customize or override your
installations specifically on the platforms which require it.

For example, you can install a package via the normal package manager on
one platform while on another, you use a custom script to install from
source.  Because the custom task is only enabled on the platform which
needs it, "jiff install" picks up on that fact and uses the appropriate
method, without having to use your command-line syntax to tell the
difference.

### Create a git repo in the root directory

    jiff slash-git

This is an example of a task that is specific to the way I administer my
systems, using a git repo to version control important configuration
files before messing with them.

### Create a new generic jiff task

    jiff task --new [task name]

### Create a new platform-specific jiff task (for the current platform)

    jiff task --new --platform [task name]

### Create a new platform-specific jiff task (for another platform)

    jiff task --new --platform=[platform name] [task name]

### Add a new platform

   jiff platform --add [platform name]

If you want the "jiff use auto" task to work with your new platform, you
will need to clone my bash-libs repo and implement your own detection in
"../bash-libs/lib/basics.sh".

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

## Built with

This repo was based on [sub].

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
