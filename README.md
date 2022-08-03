# wrouesnel-pbuilder

This is my bundle of setup scripts to make using [pbuilder](https://launchpad.net/ubuntu/+source/pbuilder)
on Ubuntu a sane and comprehensible experience for modifying and patching your
own system.

The goal here is that everything stays semi-associated to your home directory.
A non-goal at the moment is removing the sudo root dependency, since that's hard.

A very specific goal is to support incremental builds - i.e. when you upgrade
a package with library dependencies, each build can depend on the next while being
installed on your system.

This approach is definitely not intended for hermetic or reproducible builds - the
goal here is to hack packages on your system in a way which leaves you the ability
to rollback by installing older versions.

I have found this system works well for me.

## Usage

Run `./setup-pbuilder-repo` in the root of the repository.

This will do a few things: generate a new GPG key as your trusted pbuilder key,
and setup the basic repository structure in your `$HOME/.cache` and `$HOME/pbuilder`
folders.

It will then also ask for sudo permissions and create `/etc/apt/sources.list.d/pbuilder.list`
to make your built packages visible to both pbuilder and your system.

