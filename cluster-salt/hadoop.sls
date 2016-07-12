hadoop:
  archive.extracted:
    - name: /usr/local/
    - source: http://apache.claz.org/hadoop/core/hadoop-2.7.1/hadoop-2.7.1.tar.gz
    - source_hash: md5=203e5b4daf1c5658c3386a32c4be5531
    - archive_format: tar
    - tar_options: -z --transform=s,/*[^/]*,hadoop,
    - if_missing: /usr/local/hadoop/
/usr/local/hadoop/etc/hadoop/masters:
  file.managed:
    - source: salt://hadoop/masters
    - overwrite: true 
/usr/local/hadoop/etc/hadoop/slaves:
  file.managed:
    - source: salt://hadoop/slaves
    - overwrite: true 
/usr/local/hadoop/etc/hadoop/core-site.xml:
  file.managed:
    - source: salt://hadoop/core-site.xml
    - overwrite: true 
/usr/local/hadoop/etc/hadoop/mapred-site.xml:
  file.managed:
    - source: salt://hadoop/mapred-site.xml
    - overwrite: true 
/usr/local/hadoop/etc/hadoop/hdfs-site.xml:
  file.managed:
    - source: salt://hadoop/hdfs-site.xml
    - overwrite: true 
/usr/local/hadoop/etc/hadoop/yarn-site.xml:
  file.managed:
    - source: salt://hadoop/yarn-site.xml
    - overwrite: true 
/data/hdfs:
  file.directory
/data/tmp:
  file.directory
