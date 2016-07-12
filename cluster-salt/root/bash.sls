/root/.bash_profile:
  file.managed:
    - source: salt://root/bash_profile
    - overwrite: true
/root/.bashrc:
  file.managed:
    - source: salt://root/bashrc
    - overwrite: true
