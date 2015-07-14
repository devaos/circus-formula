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

## Minimal Config

You must specify a pillar such as the following to launch `my_program` via Circus.

```yaml
circus:
  watcher:
    my_program:
      cmd: /path/to/my_program
```

Every other configuration option is totally optional.  For more information see [Circus configuration docs](http://circus.readthedocs.org/en/latest/for-ops/configuration/).

## `circus:ini`

This pillar contains name=value pairs that go into the `[circus]` stanza of `circus.ini`

#### Example pillar

```yaml
circus:
  ini:
    check_delay: 5
    loglevel: DEBUG
```

#### Resulting stanza `circus.ini`

```ini
[circus]
check_delay = 5
loglevel = DEBUG
```

## `circus:env`

Set global environment variables for all watchers.

#### Example pillar

```yaml
circus:
  env:
    FOO: foo
    TASTY: lettuce
```

#### Resulting stanza in `circus.ini`

```ini
[env]
FOO = foo
TASTY = lettuce
```

## `circus:service`

This contains configuration specific to running the circus service on the system.

Supported options:

### `max_shutdown_time`

The amount of time to wait (in seconds) for circus to shut down
after having sent a `SIGTERM` before we give up on it and send it a `SIGKILL`.

As usual on Unix, `SIGKILL` causes the application to shut down, and can cause data loss.

Used during system shutdown when we're trying to stop the service, and also during any restarts
you may invoke via `/etc/init.d/circus restart`.

#### Example pillar

```yaml
circus:
  service:
    max_shutdown_time: 30
```

## `circus:plugin`

List all plugins loaded during startup and reload.

#### Example pillar

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
#### Resulting stanza in `conf.d/plugin_statsd.ini`

```ini
[plugin:statsd]
use = circus.plugins.statsd.StatsdEmitter
host = localhost
port = 8125
sample_rate = 1.0
application_name = example
```

## `circus:socket`

List all sockets that Circus should bind to and listen on.

#### Example pillar

```yaml
circus:
  mysocket:
    host: localhost
    port: 8080
```

#### Resulting stanza in `conf.d/socket_mysocket.ini`

```ini
[socket:mysocket]
host = localhost
port = 8080
```

## `circus:watcher`

List all watchers that Circus should start. All keys except `env` directly relate to a Circus configuration directive. Use `env` to set environment variables for a specific watcher.


#### Example pillar

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

#### Resulting stanzas in `conf.d/watcher_myprogram.ini`

```ini
[watcher:myprogram]
cmd = python myprogram.py
numprocesses = 5
hooks.before_start = my.hooks.control_redis
stdout_stream.class = FileStream
stdout_stream.filename = test.log
stdout_stream.max_bytes = 1073741824
stdout_stream.backup_count = 5
stderr_stream.class = FileStream
stderr_stream.filename = error.log

[env:myprogram]
PROGRAM_ENV = yes
```
