spark:
  archive.extracted:
    - name: /usr/local/
    - source: http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-without-hadoop.tgz
    - source_hash: md5=e0effe0f2f308029f459fb0bb86ca885
    - archive_format: tar
    - tar_options: -z --transform=s,/*[^/]*,spark,
    - if_missing: /usr/local/spark/
/usr/local/spark/conf/slaves:
  file.managed:
    - source: salt://spark/slaves
    - overwrite: true
/data/spark:
  file.directory
/data/spark/local:
  file.directory
/data/spark/worker:
  file.directory
