This container sets up a cfengine policy-hub.

The default policy set is included, and has autorun enabled. A supplemental policy is included to install `sshd`.

When the container starts it will:

* generate keys if they don't already exist
* bootstrap to itself
* run `cf-agent`
* start `cf-serverd`

The `cf-serverd` process runs in verbose mode and the output is available in the container log.
