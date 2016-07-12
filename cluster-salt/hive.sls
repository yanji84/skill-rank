hive:
  archive.extracted:
    - name: /usr/local/
    - source: http://archive.apache.org/dist/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz 
    - source_hash: md5=3f51e327599206f1965e105de7be68eb
    - archive_format: tar
    - tar_options: -z --transform=s,/*[^/]*,hive,
    - if_missing: /usr/local/hive/
