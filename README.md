This container sets up a cfengine policy-hub.

The default policy set is included, and has autorun enabled.
Supplemental policies are included to install `sshd` and to activate a
Design Center sketch.

When the container starts it will:

* generate keys if they don't already exist
* bootstrap to itself
* run `cf-agent`
* start `cf-serverd`

The `cf-serverd` process runs in verbose mode and the output is available in the container log.

If you run `make run WITH_MASTERFILES=/my/path/masterfiles` then that
path will be mounted under `/var/cfengine/masterfiles` so both the
container and you can access and modify them. The autorun flag and the
policy to install sshd are not going to be used, since you're
providing your own masterfiles. This is a very convenient way to test
your own masterfiles.

If you run `make run WITH_TESTFILES=/my/path/testfiles` then that path
will be mounted under `/opt/local/lib/testfiles` and
`/my/path/testfiles/promises.cf` will be executed from that mount.
This is a very convenient way to test your own policies **without**
overriding the masterfiles, and produces a log of the changes to `/etc`. As an example,

```console
% make build test WITH_TESTFILES=/my/path/testfiles
```

will run `/my/path/testfiles/promises.cf` and produce test logs,
including filesystem diffs, in
`/my/path/testfiles/testruns/2016-02-11-24:17:21/*.log`.

If you run `make run WITH_SKETCHES=/my/path/design-center/sketches`
then that path will be mounted under
`/var/cfengine/design-center/sketches` so both the container and you
can access and modify them. The Design Center policy will use that
directory to install the sketches, so this is a very convenient way to
test your own sketches.
