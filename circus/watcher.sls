{% from "circus/map.jinja" import circus with context %}

include:
  - circus.conf

{% for watcher, config in salt['pillar.get']('circus:watcher', {}).iteritems() %}
{{ circus.conf_dir }}/conf.d/watcher_{{ watcher }}.ini:
  file:
{% if config.get('enabled', True) %}
    - managed
    - mode: 0644
    - source: salt://circus/templates/watcher.ini.tmpl
    - template: jinja
    - context:
      watcher: {{ watcher }}
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
