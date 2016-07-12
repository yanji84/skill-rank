elasticsearch:
  archive.extracted:
    - name: /usr/local/
    - source_hash: sha1=e369d8579bd3a2e8b5344278d5043f19f14cac88
    - source: https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.0.0/elasticsearch-2.0.0.tar.gz
    - archive_format: tar
    - tar_options: -z --transform=s,/*[^/]*,elasticsearch,
    - if_missing: /usr/local/elasticsearch/
/usr/local/elasticsearch/config/elasticsearch.yml:
  file.managed:
    - template: jinja
    - source: salt://elasticsearch/elasticsearch.yml
    - overwrite: true
/data/elasticsearch:
  file.directory
/data/elasticsearch/data:
  file.directory
/data/elasticsearch/work:
  file.directory
/data/elasticsearch/logs:
  file.directory
/data/elasticsearch/plugins:
  file.directory
