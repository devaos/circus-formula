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

[example.pillar](example.pillar) shows all the possible options you can set.

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
