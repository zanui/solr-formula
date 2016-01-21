#sls
{% set jdk_version = salt['pillar.get']('jdk:version', '1.7.0_21') %}

jdkbasedirectories:
  file.directory:
    - name: /usr/lib/jvm/releases/
    - makedirs: True

jdkextract:
  archive.extracted:
    - name: /usr/lib/jvm/releases/
    - source: salt://solr/files/jdk{{ jdk_version }}.gz
    - archive_format: tar
    - if_missing: /usr/lib/jvm/releases/jdk{{ jdk_version }}/bin

{% set alts = ['java', 'javac', 'javaws', 'jar', 'jps'] -%}
{% for alt in alts %}
{{ alt }}:
  alternatives.install:
    - link: /usr/bin/{{ alt }}
    - path: /usr/lib/jvm/releases/jdk{{ jdk_version }}/bin/{{ alt }}
    - priority: 1
    - require:
      - archive: jdkextract
{% endfor %}
