#! /bin/bash

/usr/sbin/fbguard -forever -pidfile /var/run/firebird/2.5/fbserver.pid
/usr/sbin/fb_smp_server
