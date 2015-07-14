{% from "circus/map.jinja" import circus with context %}

{% for plugin, config in salt['pillar.get']('circus:plugin', {}).iteritems() %}

/etc/logrotate.d/circus:
  file:
  {% if config.get('enabled', True) %}
    - managed
    - source: salt://circus/templates/circus.logrotate.tmpl
    - template: jinja
    - mode: 0660
  {% else %}
    - absent
  {% endif %}
{% endfor %}
