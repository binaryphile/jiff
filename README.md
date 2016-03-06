## Jiff

[Jiff] is an automation notebook.  Jiff helps you turn your command-line
system configuration rituals into simple tasks, available wherever you
need them.

Jiff gives you a command, "jiff", which allows you to create subcommands
called tasks (e.g. "jiff mytask").  Jiff makes it simple to create new
tasks by providing a basic script template that also pulls in your bash
history, so you can capture whatever it is you just finished working on.

Jiff tasks are not limited to scripts as they can be any executable,
although it is tailored for scripting.

If you work on a lot of systems, scripts tends to work fine if you have
multiple similar machines, but typically won't work when changing
platform or environment.  For example, scripts written for Red Hat Linux
won't work on Ubuntu and vice-versa.  Scripts written for servers may
not work on desktops.

Some systems may use different commands, or call software packages by
different names.  Others may have constraints like firewalls that don't
allow access to your usual download sites.

Jiff calls these factors which prevent reusability "contexts".

One way scripts can handle such contextual differences is to add
complexity.  Logic can be introduced to detect and accommodate the
differences in environment.  Gradually scripts becomes more general at
the expense of complexity and maintainability.

Jiff takes a different approach.  Rather than try to make one script to
rule the different environments, it instead makes it easy to write
scripts which are only need to worry about one environment.

When you change contexts, moving to a different system, you can
construct a different script with the same name, a script which embraces
the assumptions of that environment and doesn't need to be generalized
at all.  A script which can be a near-verbatim transcript of the steps
you would do by hand.  That is what enables jiff to make use of your
shell history when writing your scripts.

By default, jiff stores your scripts in a directory that specifies most
of the things which might keep it from running elsewhere.  That
includes:

- a name chosen by you to describe the context, e.g. "work" or "home"
- the detected OS distribution on which you are running, e.g. "centos-6"
  or "ubuntu-15"
- the role that you have on that machine, e.g. "admin" or "user"

You can define contexts with any name you like, and you can also nest
them with "/", e.g. "work" and "work/vagrant".  You can also define new
roles, although "admin" and "user" tend to capture most needs.  Jiff
defaults to the "admin" role since it is mostly meant to be used for
system administration.

When you install jiff on another system, you only need to configure the
context name.  If the rest of the environment matches the original one
(role and distro), then your original jiff tasks become available.

The nice thing is that when you're in a new context, you have carte
blanche to write a new script for a task of the same name.  Just do what
you would normally do in the new environment, then capture it as a task.
This is why I call jiff a notebook, since it basically takes notes on
what you've done and makes them available as tasks.

As your task library grows, it becomes multiplatform (I would say
"multicontext") with minimal effort.  By compartmentalizing scripts into
their own environments, they can embrace their own set of assumptions
instead of abstracting them away.

The end result is simplicity for you.  For example, on any system I can
run "jiff install git" and I will get the latest version of git
installed, independent of:

- whether or not it is in the package repositories
- the dependencies required to compile it from source
- whether I have access to the source download site
- the package management command syntax
- whether I am a system admin (global install) or a regular user (local
  install)

Once this is true of all of your tasks, you can start writing system
configuration scripts built on them.  This allows you to specify your
configuration in an entirely system-independent manner.  Much like
Ansible or SaltStack allow you to do, but tailored to the way you
already do things, in shell, without having to learn how to do it "their
way".

That's the core idea of jiff, but it has other features to make life
easier as well.  Jiff allows you to deploy your tasks to other machines
simply.  It allows you to stay up-to-date with changes in the jiff-core
project without having to perform git merges, despite being a fork.  And
it allows you to sensibly build abstraction into your tasks whenever you
like, without forcing you to do so.

## Support

Jiff currently has explicit support for Ubuntu 14, 15, CentOS 6 and Red
Hat 6, although it will work on any standard unix which supports
symlinks.

## Dependencies

Jiff requires a github account and git.  It also requires you to fork
this repository, which the installer does automatically.

Jiff is implemented in bash, which must be installed on your system.  It
also requires Python 2.

Jiff supports any shell environment, but requires your initialization
scripts (bashrc et. al.) to load it onto your path.  The installer does
this automatically for bash but not the others at the moment.  If you
use fish, zsh or the like, you will need to follow the [basher]
instructions for configuring your initialization scripts.  Once basher
is available on your path, jiff is automatically available as well.

## Installation

User-land install (no sudo necessary):

    curl -sL https://raw.githubusercontent.com/binaryphile/jiff/master/install-jiff | bash

NOTE: you will be prompted to fork this repository to your github
account!  The script will do this for you, but you will be running your
own copy of the jiff repo.

Along with creating your new jiff repo, it will install [basher] in the
user's home directory, as well as add both jiff and basher to the path.

There currently is no global system installer.

## Tasks

Jiff comes with just the functionality necessary to manage itself.
You're expected to provide scripts for what you want it to automate.

Jiff's bread and butter are called tasks, which are simply scripts (or
even programs) you create with a special name.  Each script is then
accessible as a subcommand to jiff, e.g.:

    jiff my_new_task

Jiff will invoke the new task you have created and pass it your
arguments as if you had run the script directly yourself.

While this is a good start, it's not very useful yet out of the box.
The rest is up to you.  You'll need to know a little bit about how jiff
works to make it work for you.

## An Example

I've just installed jiff on my home system.  Since I'm running fish as
my shell, I've updated my `config.fish` file to put jiff on my path.  I
re-enter my shell, or source `config.fish`, to make jiff available.

The first thing I do is create a context:

```
> jiff context add home
```

and check it with:

```
> jiff context
Usage: jiff context CONTEXT|none [rhel-6|centos-6|ubuntu-14|ubuntu-15]

Available contexts:

home

Currently using: home
```

I could have also run `jiff status`, which tells me my role as well as
context.  The role task also tells you your role:

```
> jiff role
Usage: jiff role ROLE

Available roles:

admin
user

Currently using: admin
```

Now let's do some work.  I want to install mysql and my standard
configuration:

```
> sudo apt-get install mysql-server >/dev/null
> curl -sL https://raw.githubusercontent.com/binaryphile/mysql/master/my.cnf | sudo tee /etc/my.cnf
> sudo service mysql start
```

Now let's turn this into a task.  Jiff has a convenience syntax for
installation tasks which we'll take advantage of:

```
> jiff task add mysql-install
```

This fires up the editor with the task template and includes the last
fifty lines of bash history for good measure.  I scrap most of the
template and leaving the lines above, then save and exit.

Jiff's builtin "install" task looks for any task with the "-install"
suffix which matches the named package, and executes that.  So the
following will run the task we just created:

```
> jiff install mysql
```

Otherwise, "jiff install [package]" runs the appropriate system package
manager to install the named package, e.g. `sudo apt-get install -y
[package]`.

The "-install" naming scheme allows you to override and extend that
behavior with your own script, as we've just done.

Finally, let's push the new task up to our jiff repo:

```
jiff task publish mysql-install
```

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
