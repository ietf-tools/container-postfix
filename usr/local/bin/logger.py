#!/usr/bin/python3
import os
import stat
import sys
f = open('/var/log/postfix/current', 'r')
#while True:
#    with open('/proc/1/fd/1', 'w') as fdfile:
#        fdfile.write(f.readline())


if __name__ == "__main__":
  logfile = '/var/log/postfix/current'
  while True:
    f = open(logfile, 'r')
    f_ino = os.stat(logfile)[stat.ST_INO]
    f_dev = os.stat(logfile)[stat.ST_DEV]
    try:
      if os.stat(logfile)[stat.ST_INO] != f_ino or os.stat(logfile)[stat.ST_DEV] != f_dev:
        break
    except OSError:
      pass
    while True:
      with open('/proc/1/fd/1', 'w') as fdfile:
          fdfile.write(f.readline())
