{% from "circus/map.jinja" import circus with context %}

include:
  - circus.conf

{% for plugin, config in salt['pillar.get']('circus:plugin', {}).iteritems() %}
{{ circus.conf_dir }}/conf.d/plugin_{{ plugin }}.ini:
  file:
{% if config.get('enabled', True) %}
    - managed
    - mode: 0644
    - source: salt://circus/templates/plugin.ini.tmpl
    - template: jinja
    - context:
      plugin: {{ plugin }}
{% else %}
    - absent
{% endif %}
    - require:
      - file: {{ circus.conf_dir }}/conf.d
    - require_in:
      - service: circus
    - watch_in:
      - service: circus
{% endfor %}
