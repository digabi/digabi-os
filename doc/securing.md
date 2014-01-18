Securing Digabi Live
=====================================================

 - Currently we create groups for grsec in `config/hooks/0005-create-groups.chroot`, these are configured in Kernel
 - https://en.wikibooks.org/wiki/Grsecurity/Application-specific_Settings



## TODO

 - rebuild kernel w/ Grsecurity
 - enable PaX, RBAC
 - add script for checking SUID/SGID binaries, require whitelisting (make build fail, if not whitelisted)
 - remove unnecessary packages
 - enable Ninja support
 - limit pkexec in non-dev builds
