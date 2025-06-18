
USP Network Authentication System ® 15.3
========================================

Released 17 June 2025

Platform Compatibility
----------------------

This release is compatible with the following platforms:

*   Dell PowerEdge R650/R640/R630/R620/R610
*   VMware ESXi / Workstation
*   Microsoft Hyper-V
*   QEMU/KVM
*   Oracle VirtualBox

Changelog
---------

### Enhancements

*   **New GUI:** The data import failure report download button is also shown for successful imports, in case some entries contain failures (#290858)
*   Added duration value to CSV data import success event log message (#290878)
*   Improved CSV data import error messages: Event CSV\_IMPORT\_NOT\_VALID (“Too many erroneous entries, CSV import aborted”) now contains the threshold value used, event CSV\_IMPORT\_NOT\_PERFORMED (“Record count is too low compared to last import from same source”) contains the current count, last count and validation threshold used, and the event message is no longer nested into a CSV\_IMPORT\_ERROR error. (#290858)

### Changes

*   Ensured that syslog messages sent by USP NAS applications have a trailing newline at the end, to ensure proper processing by certain syslog servers. The newline was removed in release 14.0 due to a replacement of the logging framework. If you are using USP NAS with a remote syslog server, we advise to validate the proper reception of log message sent by USP NAS. (#290890)
*   If a WLAN AP/controller is being auto-added via RADIUS request subnet match, it will now get the device class WLAN instead of Generic RADIUS auth. device. This will ensure it is scanned in the correct way in case an SNMP access profile is defined. (#290840)
*   When auto-adding via RADIUS request subnet match, no “fake” Generic Radius adapter is set anymore. The adapter will be set by the normal switch scan process, and the WebGUI will now show the correct status of the newly added netdevice. (#290068)

### Bugfixes

*   **New GUI:** Improved the performance of bulk-deleting large amounts of soft-deleted netdevices via the web GUI (“Deleted Netdevices” page) (#290985)
*   Changed the id column of the endpoint details table to be an identity column instead of using global ids, in order to avoid conflicts and race conditions when dealing with large data imports. (#290955)
*   Fixed a data migration issue during release upgrade which occurred when no RADIUS subnets were defined (#290906)
*   Fixed an issue in the portgroup mapping CSV data importer where a mapping was unintentionally assigned to an single interface by interface index, when using a wildcard character as interface name (%) to assign the portgroup to the entire netdevice. (#291001)
*   Fixed an issue where an EAP cache registered endpoint did not get removed, as intended, when an invalid certificate was supplied (#290841)
*   Fixed an issue which caused some syslog server settings (protocol, format) to be reset to their default value during release upgrade (#290891)
*   Fixed an issue which prevented the interface alias uplink matcher to work correctly with multiple devices. It is now also ensured that manually defined netports are never overwritten or removed by the uplink matcher. (#290954)
*   Fixed an issue with scanning netdevices using SNMPv3 when multiple users with different credentials are configured (#291108)
*   Fixed event log message RADIUS\_SERVER\_REJECT(1171) so that it does again contain proper information on why a certificate was rejected by the internal RADIUS server during authentication. (#241761)
*   Fixed incorrect error count in data import. This could happed under certain circumstances when dealing with duplicate entries in the import file (#290878)
*   Fixed the netdevice CSV data importer so that the default SNMP access profile is assigned to an entry if it requires SNMP but has empty community/username fields (#290877)