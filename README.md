# About checkrestart
Yes this is yet another tool inspired by checkrestart from debian-goodies. This one aims to be easily portable to non-debian distributions and also to provide slightly different informations.

# Usage
`checkrestart [options]`

Where options can be:

  * `-h` Shows help
  * `-v` Makes the script more verbose (and slower)
  * `-q` Makes the script less verbose (and quicker)

### Example:
```
$ ./checkrestart.sh -v
/usr/lib/systemd/systemd-journald
    PID:            114
    User:           root
    Running since:  Mon Feb 29 22:08:13 2016
    Deleted files:  /usr/lib/libgcrypt.so.20.0.5 (N/A)
                    /usr/lib/libgpg-error.so.0.17.0 (N/A)
                    /usr/lib/ld-2.23.so (glibc)
                    /usr/lib/libc-2.23.so (glibc)
                    /usr/lib/libpthread-2.23.so (glibc)
                    /usr/lib/librt-2.23.so (glibc)
                    /usr/lib/systemd/systemd-journald (systemd)

/usr/bin/ntpd -g -u ntp:ntp
    PID:            284
    User:           ntp
    Running since:  Mon Feb 29 22:08:21 2016
    Deleted files:  /usr/bin/ntpd (ntp)
                    /usr/lib/ld-2.23.so (glibc)
                    /usr/lib/libc-2.23.so (glibc)
                    /usr/lib/libcrypto.so.1.0.0 (openssl)
                    /usr/lib/libdl-2.23.so (glibc)
                    /usr/lib/libgcc_s.so.1 (gcc-libs)
                    /usr/lib/libm-2.23.so (glibc)
                    /usr/lib/libnss_dns-2.23.so (glibc)
                    /usr/lib/libnss_files-2.23.so (glibc)
                    /usr/lib/libnss_myhostname.so.2 (libsystemd)
                    /usr/lib/libpthread-2.23.so (glibc)
                    /usr/lib/libresolv-2.23.so (glibc)
                    /usr/lib/librt-2.23.so (glibc)

/usr/lib/systemd/systemd --user
    PID:            359
    User:           h
    Running since:  Mon Feb 29 22:08:50 2016
    Deleted files:  /usr/lib/libseccomp.so.2.2.3 (N/A)
                    /usr/lib/ld-2.23.so (glibc)
                    /usr/lib/libblkid.so.1.1.0 (libutil-linux)
                    /usr/lib/libc-2.23.so (glibc)
                    /usr/lib/libdl-2.23.so (glibc)
                    /usr/lib/libmount.so.1.1.0 (libutil-linux)
                    /usr/lib/libnss_files-2.23.so (glibc)
                    /usr/lib/libpthread-2.23.so (glibc)
                    /usr/lib/librt-2.23.so (glibc)
                    /usr/lib/libuuid.so.1.3.0 (libutil-linux)
                    /usr/lib/systemd/systemd (systemd)

ssh-agent
    PID:            394
    User:           h
    Running since:  Mon Feb 29 22:08:50 2016
    Deleted files:  /usr/bin/ssh-agent (openssh)
                    /usr/lib/ld-2.23.so (glibc)
                    /usr/lib/libc-2.23.so (glibc)
                    /usr/lib/libcrypto.so.1.0.0 (openssl)
                    /usr/lib/libdl-2.23.so (glibc)

Found 4 out-of-date processes!
```

# Support
This script currently fully supports
 - Debian based distributions
 - Arch Linux based distributions

Partial functionality can be expected on other systems. Pretty much everything except of `-v` switch should work anywhere.

# Dependencies
Checkrestart makes use of `lsof`, `readlink` and `xargs`, so these programs must be installed to assure proper functioning. Also, when running with `-v`, package management commands are used (`dpkg` or `pacman`, depending on distribution) - but those should be always available in any reasonable distro.
