## Jiff

[Jiff] is an automation notebook.  Jiff helps you turn your command-line
system configuration rituals into simple tasks, available wherever you
need them.

Jiff makes available a command, "jiff", which allows you to create
subcommands called tasks (e.g. "jiff mytask").  Jiff makes it simple to
create new tasks by providing a basic script template that also pulls in
your bash history, so you can capture whatever it is you just finished
working on.

Jiff tasks are not limited to scripts.  They can be any executable,
although it is tailored for scripting.

## Motivation

Jiff's goal is to make it possible to create system-independent
configuration scripts without needing complex logic to deal with the
differences in environments.

If you work on a lot of systems, scripts work fine so long as you have
multiple similar machines.  As soon as you introduce new platforms or
environment constraints, they break however.

For example, scripts written for Red Hat Linux won't work on Ubuntu and
vice-versa.  Scripts written for servers may not work on desktops.  Some
systems may use different commands, or call software packages by
different names.  Others may be subject to constraints such as firewalls
which don't allow access to the usual download sites.

Jiff calls these factors which prevent reusability "contexts".

## Strategy

One way scripts can handle such contextual differences is to add
complexity.  Logic can be introduced to detect and accommodate the
differences in environment.  Gradually scripts becomes more general at
the expense of complexity and maintainability.

Jiff takes a different approach.  Rather than try to make "one script to
rule" the different environments, it instead makes it easy to write
scripts which only need to worry about one environment.  It does so by
pulling a switcheroo.  It lets you create multiple versions of the same
script under the same name...one for each context.  When you switch
contexts, it makes the proper version available automatically.

If your script only has to deal with its own context, the more it looks
like the steps you would take by hand on the command line.  In fact,
they can be exactly that simple.  That's why I call jiff a notebook...
it basically takes notes on what you've done and makes them available as
tasks.  What jiff adds is automatic organization and availability by
context.

## Contexts

By default, jiff stores your tasks in a directory that specifies most of
the things which might keep it from running elsewhere.  That includes:

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

## System/Context Independence

As your task library grows, it becomes multiplatform as you implement
the same task for multiple contexts.

In many cases, you'll just want to record your manual steps from each
environment.  If you're inclined to write a single script which handles
more than one context, jiff also offers sensible means for reusing code
and promoting tasks to be available across contexts.  Jiff can also
override a more-general task with a specific one tailored for a one-off
context.

The end result is simplicity for you.  For example, on any system I can
run "jiff install git" and I will get the latest version of git
installed, independent of:

- whether or not it is in the package repositories
- the dependencies required to compile it from source
- whether I have access to the source download site
- the package management command syntax
- whether I am a system admin (global install) or a regular user (local
  install)

## System Configuration Automation

Once your system configuration tasks handle all of your contexts, you
can build system configuration scripts with them.  This allows you to
specify your configuration in an entirely system-independent manner,
constructed of jiff tasks.  Much like [Ansible] or [SaltStack] allow you
to do, but tailored to the way you already do things, in shell, without
having to learn how to do it "their way".

## Other Features

That's the core idea of jiff, but it has other features to make life
easier as well.  Jiff allows you to deploy your tasks to other machines
simply.  It allows you to stay up-to-date with changes in the jiff-core
project without having to perform git merges (usually), despite being a
fork.  And it allows you to sensibly build abstraction into your tasks
whenever you like, without forcing you to do so.

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

## TODO

Some of this isn't done yet.

- deploy and update jiff remotely
- automatic context detection
- dependency specification in task headers
- polish and trim

## References

If you're interested in system configuration automation and/or bash
scripting, here are some resources which inspired jiff:

- [ansible]
- [basher]
- [chef]
- [fucking_shell_scripts]
- [puppet]
- [rake]
- [saltStack]
- [sub]

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
