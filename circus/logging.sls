/etc/logrotate.d/circus:
  file:
  {% if salt['pillar.get']('circus') %}
    - managed
    - source: salt://circus/templates/circus.logrotate.tmpl
    - template: jinja
    - mode: 0660
  {% else %}
    - absent
  {% endif %}
