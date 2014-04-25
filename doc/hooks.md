live-build hooks
=========================

Rules for naming `config/hooks`.

 - 9000: security checks
 - 8000: hardening the system
 - 7000: configure login manager, user accounts etc.
 - 6000: user-provided customization (especially for buildbox use)
 - 5000: customize environment (user defaults etc.)
 - 4000: update system data
 - 3000: remove extra files
 - 2000: remove extra packages
 - 1000: update system configuration
 - 0000: set metadata
