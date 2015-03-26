{% from "circus/map.jinja" import circus with context %}

include:
  - circus.conf

{% for socket, config in salt['pillar.get']('circus:socket', {}).iteritems() %}
{{ circus.conf_dir }}/conf.d/socket_{{ socket }}.ini:
  file:
{% if config.get('enabled', True) %}
    - managed
    - mode: 0644
    - source: salt://circus/templates/socket.ini.tmpl
    - template: jinja
    - context:
      socket: {{ socket }}
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
