## Jiff

A tool to make setting up systems and my personal environment easier.

- Platform independent
- Easily installed and upgraded using [basher]
- Shell scripts!

After having worked with everything from Ansible to Rake, I found I just
wanted something that would let me bring a bare machine up to my
environment with a minimum of fuss.  I wanted shell scripts so I could
go back over the setup I had just done manually and condense it into a
jiff command then and there.

Jiff is a work in progress and is specific to my dotfiles and workflow.
Feel free to build off it.

Jiff commands should check to see whether their particular job has
already been done and exit gracefully (return 0) if so.  That allows any
jiff command can run another jiff command as a prerequisite and not have
to worry that the prereq will have problems if, for example, it has been
called twice because two parts of the task have the same prereq.

Prior to using any platform-specific jiff commands, you'll want to run
"jiff use auto" to set up the links for your distro (ubuntu, centos,
etc.)

## Installation

### Pipethis

Using [pipethis] you can run the installer thusly:

    pipethis https://raw.githubusercontent.com/binaryphile/jiff/master/install-jiff.sh

Or, if you're more trusting:

    curl https://raw.githubusercontent.com/binaryphile/jiff/master/install-jiff.sh | bash

## Built with

This repo was based on [sub].

[basher]: https://github.com/basherpm/basher
[pipethis]: https://github.com/elloteth/pipethis
[sub]: https://github.com/basecamp/sub
