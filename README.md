Circus Salt Formula
===================

Install and configure [Circus](http://circus.readthedocs.org/en/latest/)

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)

## Available States

- [circus](#circus)


### circus

Install Circus and its dependencies, set up config files and start the service.


Configuration
=============

[pillar.example](pillar.example) shows all the possible options you can set.

Options are based directly on the
[Circus Configuration File Specification](http://circus.readthedocs.org/en/latest/for-ops/configuration/)
and are current as of 0.11.1 (March 2015).

## Bare Minimum Config

At the very least you must specify a pillar such as the following to launch `my_program` via Circus.

```yaml
circus:
  watcher:
    my_program:
      cmd: /path/to/my_program
```

Every other configuration option is totally optional.  Default values are documented by Circus, see the
[configuration docs](http://circus.readthedocs.org/en/latest/for-ops/configuration/)
for more info.

## circus:ini

This pillar contains name=value pairs that go into the `[circus]` stanza of `circus.ini`

Example pillar

```yaml
circus:
  ini:
    check_delay: 5
    loglevel: DEBUG
```

Resulting `circus.ini`

```ini
[circus]
check_delay = 5
loglevel = DEBUG
```

## circus:env

Global environment variables to be set for all watchers.

Example pillar

```yaml
circus:
  env:
    FOO: foo
    BAR: bar
    TASTY: lettuce
```

## circus:service

This contains configuration specific to running the circus service on the system.

Currently supported options:

### `max_shutdown_time`

The maximum amount of time to wait (in seconds) for circus to shut down
after having sent a `SIGTERM` before we give up on it and send it a `SIGKILL`.

As usual on Unix, `SIGKILL` causes the application to absolutely shut down, and likely causes data loss.

This is used during system shutdown when we're trying to stop the service, and also during any restarts
you may invoke via `/etc/init.d/circus restart`.

Example pillar

```yaml
circus:
  service:
    max_shutdown_time: 30
```

## circus:plugin

List all plugins to be loaded during startup and reload.

Example pillar

```yaml
circus:
  plugin:
    statsd:
      use: circus.plugins.statsd.StatsdEmitter
      host: localhost
      port: 8125
      sample_rate: 1.0
      application_name: example
```

## circus:socket

List all sockets that Circus should bind to and listen on.

Example pillar

```yaml
circus:
  mysocket:
    host: localhost
    port: 8080
```

## circus:watcher

List all watchers that Circus should start.

There is a special setting `circus:watcher:*:env` which is a dict containing environment variables
that should be set for this watcher only.

With the exception of the `env` key, all other keys directly relate to a Circus configuration directive.

Example pillar

```yaml
circus:
  watcher:
    myprogram:
      cmd: python myprogram.py
      numprocesses: 5
      env:
        PROGRAM_ENV: yes
      hooks:
        before_start: my.hooks.control_redis
      stdout_stream:
        class: FileStream
        filename: test.log
        max_bytes: 1073741824
        backup_count: 5
      stderr_stream:
        class: FileStream
        filename: error.log
```
