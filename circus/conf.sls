{% from "circus/map.jinja" import circus with context %}

{{ circus.conf_dir }}:
  file.directory:
    - mode: 0755
    - makedirs: True

{{ circus.conf_dir }}/conf.d:
  file.directory:
    - mode: 0755
    - require:
      - file: {{ circus.conf_dir }}

{{ circus.conf_dir }}/circus.ini:
  file.managed:
    - source: salt://circus/templates/circus.ini.tmpl
    - template: jinja
    - mode: 0644
    - require:
      - file: {{ circus.conf_dir }}
