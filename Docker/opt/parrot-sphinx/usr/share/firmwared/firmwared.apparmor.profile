 flags=(attach_disconnected,chroot_relative) {
# firmwared will load it, with "profile %S1% " prepended,
# with :
#   S1: the instance unique name

# give the instances all the capabilities known so far. This is surely overkill
# and can surely be refined. I gladly accept patches
   capability sys_chroot,
   capability sys_admin,
   capability chown,
   capability dac_override,
   capability dac_read_search,
   capability fowner,
   capability fsetid,
   capability kill,
   capability setgid,
   capability setuid,
   capability setpcap,
   capability linux_immutable,
   capability net_bind_service,
   capability net_broadcast,
   capability net_admin,
   capability net_raw,
   capability ipc_lock,
   capability ipc_owner,
   capability sys_module,
   capability sys_rawio,
   capability sys_chroot,
   capability sys_ptrace,
   capability sys_pacct,
   capability sys_admin,
   capability sys_boot,
   capability sys_nice,
   capability sys_resource,
   capability sys_tty_config,
   capability mknod,
   capability lease,
   capability audit_write,
   capability audit_control,
   capability setfcap,
   capability mac_override,
   capability mac_admin,
   capability syslog,

   signal,
   mount,
   umount,
   network,
   ptrace,

    # the following rules will allow browsing the instance filesystem
   / r,
   /* r,
   /** r,

   # the following rule could probably be split/rewritten
   /{proc,dev}/ rw,
   /{proc,dev}/** lrwix,

# Note: prepending with keyword 'audit' causes real time issue due to heavy
# throughput of logs
   /bin/* ix,
   /data/** lrwk,
   /dev/shm/* k,
   /etc/* rwm,
   /etc/** rwm,
   /factory/ lrwk,
   /factory/* lrwk,
   /lib/* rm,
   /lib/** rm,
   /mnt/ rw,
   /mnt/* r,
   /mnt/** r,
   /sbin/* ix,
   /simulator/wrappers/* ix,
   /usr/lib/valgrind/* ix,
   /simulator/ rwlk,
   /simulator/* rwlk,
   /simulator/** rm,
   /simulator/sys/** rw,
   /sys/devices/virtual/misc/ulog_main/** rw,
   /tmp/* ix,
   /tmp/** rwkl,
   /usr/bin/* ix,
   /usr/lib/* lrwm,
   /usr/lib/** lrwm,
   /usr/sbin/* ix,
   /usr/libexec/** ix,
   /var/** rwlk,

   /usr/sbin/ftpd cx -> ftpd,

# Note that deny rules are evaluated after allow rules so they cannot be
# overidden by an allow rule

# ... then we restrict what is suspected (or known) to be harmful
   audit deny /proc/sysrq-trigger lrwx,
   audit deny /dev/hd** lxrw,
   audit deny /dev/sd? lx,
   # below, we voluntarily skip "sd.1" devices so that user-storaged (from
   # Anafi) can format partitions belonging to the removable disk.
   audit deny /dev/sd[a-z][2-9] lwrx,
   audit deny /dev/mem lrwx,
   audit deny /dev/watchdog** lrwx,
   audit deny /dev/disk/** lrwx,
   audit deny /dev/disk/ lrwx,
   # the following rule will block /proc/sys/vm/overcommit_memory, /proc/sys/vm/overcommit_ratio
   audit deny /proc/sys/vm/** lwx,

# We need a special profile for ftpd because it performs a chroot which makes
# inapplicable all paths from the default profile (since we are under
# "chroot_relative" flag).
   profile ftpd flags=(attach_disconnected,chroot_relative) {
      capability sys_chroot,
      capability dac_override,
      network,
      / rwm,
      /* rwm,
      /** rwm,
   }

}
