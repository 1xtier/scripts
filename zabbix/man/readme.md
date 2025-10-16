## zabbix_agentd.conf
#### check zfs
```ini
UserParameter=zpool.check,/etc/zabbix/scripts/zpool_check.pl
```

## trigger
#### check zfs
```
{Template ZFS Pool:zpool.check.str(degraded)}=1
```
