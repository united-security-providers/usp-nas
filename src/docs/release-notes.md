# USP Network Authentication System &reg; 15.4

Released 13 August 2025

## Platform Compatibility

This release is compatible with the following platforms:

* Dell PowerEdge R660/R650/R640/R630/R620/R610
* VMware ESXi / Workstation
* Microsoft Hyper-V
* QEMU/KVM
* Oracle VirtualBox

## Changelog

### Enhancements

* *RADIUS:* Added log event `RADIUS_NETDEVICE_ADDED (1935)` which is triggered when a new netdevice from a RADIUS subnet is automatically added to the inventory (#291230)

### Changes

* *Logging:* **CAUTION** Added missing vendor name and event exception to connection event message which is sent to syslog, email and SNMP trap receivers. The message contains two new fields `exceptiontype` and `vendor`, so existing log collection systems might need to be adapted. (#291246)
* *Logging:* Added an optional trace log file for USP NAS Core and changed the log level of certain log statements (e.g. task start/finish) to "trace" in order to reduce verbosity. This will significantly reduce the size of the debug log and  make it easier to find relevant entries when debugging an issue. The trace log can be enabled by starting USP NAS core with the Java option `-Dtrace.logging.enabled=true`. The debug log events `CONFIG_UPDATED (1009)`, `START_CMDQUEUE_CHECK (1925)` and `CMDQUEUE_CHECK_COMPLETED (1926)` have been removed. (#291232)
* *REST-API:* **CAUTION** Soft-deleted netdevices are no longer included in the netdevice REST API response. The related filter parameters `deletedBefore` and `deletedAfter` have been removed. The interface REST API response will also no longer contain records belonging to soft-deleted netdevices. (#290834)

### Bugfixes

* *Data import:* When importing netdevices via CSV, the switch adapter is no longer reset. This prevents extended switch scans after each full import. (#291249)
* *Legacy GUI:* Fixed broken icon link to add an endpoint temporarily in the connection events table (#291227)
* *Modern GUI:* Fix downloading server certificate file as well as creating CSRs when using a certificate based on a elliptic curve private key. (#291287)
* *RADIUS:* Fix reading and writing elliptic curve-based private key files when updating the FreeRADIUS configuration during USP NAS Core startup. (#291287)
* *RADIUS:* Fixed an issue in RADIUS request processing where a connection abort event with error type "Object missing in context" was logged when the related netdevice was of class SWITCH and had no netports assigned. Now the proper error type "No netport defined" will be logged and shown in connection events. (#291231)
* *RADIUS:* Fixed an issue where no connection abort events were shown for EAP requests in case of a RADIUS secret mismatch (#291220)
* *RADIUS:* Fixed an logging issue in the RADIUS message authentication validator in case of a shared secret mismatch. It no longer fails silently without creating a connection abort event when it is the first time a client device gets connected to a specific interface. When the netdevice is unknown and not part of a configured RADIUS subnet or out of scope, a RADIUS_AUTHENTICATOR_OUT_OF_SCOPE log event is created instead. (#291172)
* *REST-API:* If a netdevice has been soft-deleted, its ID and the related interface index are no longer included in the results of the endpoint REST API query (#291203)
* *Upgrade:* Fixed an issue in properly assigning AES + SHA-2 SNMP access profiles during database migration when upgrading from USP NAS < 15.x (#291244)

