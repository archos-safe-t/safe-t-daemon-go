getent group safe-t-daemon >/dev/null || groupadd -r safe-t-daemon
getent group plugdev >/dev/null || groupadd -r plugdev
getent passwd safe-t-daemon >/dev/null || useradd -r -g safe-t-daemon -d /var -s /bin/false -c "Safe-T Bridge" safe-t-daemon
usermod -a -G plugdev safe-t-daemon
touch /var/log/safe-t-daemon.log
chown safe-t-daemon:safe-t-daemon /var/log/safe-t-daemon.log
chmod 660 /var/log/safe-t-daemon.log
