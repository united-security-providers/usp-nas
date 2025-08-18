
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





# USP Network Authentication System &reg; 15.3

Released 18 August 2025

## Platform Compatibility

This release is compatible with the following platforms:

* Dell PowerEdge R660/R650/R640/R630/R620/R610
* VMware ESXi / Workstation
* Microsoft Hyper-V
* QEMU/KVM
* Oracle VirtualBox

## Changelog

### Enhancements

* **New GUI:** The data import failure report download button is also shown for successful imports, in case some entries contain failures (#290858)
* Added duration value to CSV data import success event log message (#290878)
* Improved CSV data import error messages: Event CSV_IMPORT_NOT_VALID ("Too many erroneous entries, CSV import aborted") now contains the threshold value used, event CSV_IMPORT_NOT_PERFORMED ("Record count is too low compared to last import from same source") contains the current count, last count and validation threshold used, and the event message is no longer nested into a CSV_IMPORT_ERROR error.  (#290858)

### Changes

* Ensured that syslog messages sent by USP NAS applications have a trailing newline at the end, to ensure proper processing by certain syslog servers. The newline was removed in release 14.0 due to a replacement of the logging framework. If you are using USP NAS with a remote syslog server, we advise to validate the proper reception of log message sent by USP NAS. (#290890)
* If a WLAN AP/controller is being auto-added via RADIUS request subnet match, it will now get the device class WLAN instead of Generic RADIUS auth. device. This will ensure it is scanned in the correct way in case an SNMP access profile is defined. (#290840)
* When auto-adding via RADIUS request subnet match, no "fake" Generic Radius adapter is set anymore. The adapter will be set by the normal switch scan process, and the WebGUI will now show the correct status of the newly added netdevice. (#290068)

### Bugfixes

* **New GUI:** Improved the performance of bulk-deleting large amounts of soft-deleted netdevices via the web GUI ("Deleted Netdevices" page) (#290985)
* Changed the id column of the endpoint details table to be an identity column instead of using global ids, in order to avoid conflicts and race conditions when dealing with large data imports. (#290955)
* Fixed a data migration issue during release upgrade which occurred when no RADIUS subnets were defined (#290906)
* Fixed an issue in the portgroup mapping CSV data importer where a mapping was unintentionally assigned to an single interface by interface index, when using a wildcard character as interface name (%) to assign the portgroup to the entire netdevice. (#291001)
* Fixed an issue where an EAP cache registered endpoint did not get removed, as intended, when an invalid certificate was supplied (#290841)
* Fixed an issue which caused some syslog server settings (protocol, format) to be reset to their default value during release upgrade (#290891)
* Fixed an issue which prevented the interface alias uplink matcher to work correctly with multiple devices. It is now also ensured that manually defined netports are never overwritten or removed by the uplink matcher. (#290954)
* Fixed an issue with scanning netdevices using SNMPv3 when multiple users with different credentials are configured (#291108)
* Fixed event log message RADIUS_SERVER_REJECT(1171) so that it does again contain proper information on why a certificate was rejected by the internal RADIUS server during authentication. (#241761)
* Fixed incorrect error count in data import. This could happed under certain circumstances when dealing with duplicate entries in the import file (#290878)
* Fixed the netdevice CSV data importer so that the default SNMP access profile is assigned to an entry if it requires SNMP but has empty community/username fields (#290877)




# USP Network Authentication System &reg; 15.2

Released 6 May 2025

## Platform Compatibility

This release is compatible with the following platforms:

* Dell PowerEdge R650/R640/R630/R620/R610
* VMware ESXi / Workstation
* Microsoft Hyper-V
* QEMU/KVM
* Oracle VirtualBox

## Changelog

### Enhancements

* **New GUI:** Improved UX of create/edit netdevice form: Fixed some validation issues, removed unnecessary confirmation dialogs, reordered and grouped inputs more logically and added explanation of the various properties.  (#290838)
* **New GUI:** It is now possible to manually set the location of netdevices of type "Generic RADIUS authentication device". (#290838)
* Added new field `status_changed` in `node` table which contains the timestamp of the status change (active, inactive, disconnected, ...) of each network node entry. (#290438)
* Improved performance and lowered memory usage of REST API calls (endpoints, netdevices, interfaces) when dealing with large datasets (#290861)

### Bugfixes

* **New GUI:** Fixed an issue where some entries were listed multiple times in certain circumstances on the endpoint overview page. (#290847)
* **New GUI:** On the connection event page, fixed broken EAP username filter, and ensured that when filtering for client name, both network and inventory-based FQDN are considered (#290837)
* **New GUI:** On the endpoint and netdevice overview pages, the source filter no longer includes sources of deleted entries. (#290862)
* **New GUI:** On the endpoint overview page, entries are again sorted by last event. (#290845)
* **New GUI:** Show case-insensitive netport auto-assignment on netdevice interface page (#290833)
* Fixed a regression which prevented a proper system configuration and network interface name migration, when upgrading directly from older USP NAS releases (<14.0) (#290859)
* Fixed an issue where a workspace change was created when restoring policy or full backups, due to an accidentally emptied profile rule table. Newly created backup files will no longer have this issue. (#290835)





# USP Network Authentication System &reg; 15.0

Released 30 March 2025

## Platform Compatibility

This release is compatible with the following platforms:

* Dell PowerEdge R650/R640/R630/R620/R610
* VMware ESXi / Workstation
* Microsoft Hyper-V
* QEMU/KVM
* Oracle VirtualBox

## Changelog

### Features

* **New GUI:** Add possibility to download data tables as Excel and CSV files in new GUI (#289554)
* **New GUI:** Basic configuration can be configured in the new GUI. (#253630)
* **New GUI:** Enhanced information about past data imports displayed in import status table (#289529)
* **New GUI:** RADIUS subnets can be defined in the new GUI. A portgroup and/or a SNMP access profile can be selected for each subnet. This enables setting SNMPv3 access credentials for auto-inventorying RADIUS authentication devices. (#256424)
* **New GUI:** SNMP access profiles can be configured in the new GUI and assigned to netdevices. (#289672)
* **New GUI:** Scheduled scripts can be added, edited and run in the new GUI. It is no longer required to edit script contents via command line. Script files which were stored in the file system are automatically migrated to the database. (#289637)

### Enhancements

* **New GUI**: A new SNMP access profile can be defined on-the-fly when adding/editing a netdevice (#290322)
* **New GUI**: ARP table is now available on netdevice detail page if device class is router (#290177)
* **New GUI**: An "Operating figures" widget has been added to the dashboard (#289799)
* **New GUI**: CA certificates can be configured in the new GUI. Each CA certificate can be used for both peripheral systems and RADIUS at the same time. (#290389)
* **New GUI**: Display which portgroup a netdevice is assigned to on the netdevice overview and details page (#290373)
* **New GUI**: In router ARP table view, the MAC vendor is shown if available, as well as the asset type and class (if the related endpoint is registered) (#290176)
* **New GUI**: Server certificate can be changed in the new GUI (#290391)
* **New GUI:** Add option to reload NAS core directly after configuration value change (#290318)
* **New GUI:** Added maintenance page with options to restart USP NAS services or reboot the system (#286317)
* **New GUI:** Added possibility to update software image in new GUI, via maintenance page. (#289900)
* **New GUI:** Login with an LDAP-backed user is now possible via the modern GUI. (#289805)
* **New GUI:** The operating mode ("daemon mode") can be easily changed from the dashboard of the new GUI. A notification is shown in the sidebar if the mode is set to off. (#289662)
* Added an interface for scheduled jython scripts to send emails. See the related template for an example. (#290233)
* Added option to limit the number of scheduled script history log entries to keep (#290302)
* Added registered endpoint asset ID to Endpoint REST API response (#290630)
* Added scheduled script template for netdevice import, demonstrating how entries can be generated which use SNMPv2 or SNMPv3 credentials (#290197)
* Hardware vendor name is now included in connection event (#289793)
* Improved RADIUS connection chart in dashboard, showing more data points by default (#290437)
* Include assigned portgroup names in interface REST API response (#290249)
* Include netport flag in interface REST API response (#289792)
* On the page where netdevices can be  added to a portgroup, show the netdevice location if available. (#290185)
* Scheduled script error message is visible in script history, in case script run failed (#290471)

### Changes

* **BREAKING:** Removed MobileIron Fetch API functionality. We advise to use a custom scheduled script instead. (#290074)
* **BREAKING:** Sending emails using SAB CLI methods is no longer possible. Scheduled scripts might need to be adapted. See the migration guide for an alternative solution. (#290233)
* Added global SNMP access profiles which replace SNMP community/username/password settings for netdevices. SNMP credentials in existing netdevice entries will be migrated to the new access profiles. Credentials provided in netdevice imports will be matched to existing access profiles. A new field is availble in netdevice imports to specify the desired SNMP access profile name. (#289672)
* Emails (scheduled reports) are being sent directly by the USP NAS application instead of using the operating system mail service (postfix). (#289866)
* In the netdevice REST API, the query filter parameter  `snmpVersion` has been replaced by `snmpAccessProfileId` which references the assigned SNMP access profile. The response will now contain the fields `snmpAccessProfileId`, `snmpAccessProfileName`, `snmpVersion`, `snmpAuthenticationAlgorithm`, `snmpEncryptionAlgorithm`. (#290220)
* It is now possible to change the NAS Core daemon mode without requiring workspace activation (#290355)
* Remove various tools from the USP Appliance OS base image to reduce space: postfix, gdb, ethtool, hwinfo, dstat, wpa_supplicant (eapol_test), sysstat, tmux (#212698)
* Standardized SAB CLI API log file names to be similar to NAC application logs (debug.log, info.log, ...) (#290628)
* The menu entry "Core configuration" is now called "Application configuration" (#5688)
* Updated Angular UI framework to version 18 (#258137)
* Updated several third-party libraries to fix reported security vulnerabilities (CVE-2024-52317, CVE-2023-5072, CVE-2024-38821, CVE-2024-1597, CVE-2024-22243, CVE-2024-22259, CVE-2024-22262, CVE-2024-38809) (#290248)

### Bugfixes

* **New GUI**: Allow RADIUS authentication netdevices to be assigned to a portgropup, instead of switches only (#290373)
* **New GUI:** Fixed an issue where filter criteria info is lost on page refresh (#289853)
* **New GUI:** Improved performance of endpoint view (last connection event time is now stored in endpoint node table) (#290372)
* Added 'Generic RADIUS Device' to the list of selectable switch adapters in netdevice filter (#289962)
* Correct network type is shown in connection event in case the netdevice is of type RADIUS authentication type (#290012)
* Fixed an error which occurred when processing a RADIUS request belonging to a soft-deleted auto-inventoried RADIUS authentication device. (#290597)
* Fixed an issue where a "Switch adaptor class loading failed (GenericRadiusAdaptor)" message was logged for generic RADIUS authentication devices (#289962)
* Fixed an issue where certain regular expressions for uplink detection could not be read correctly from the configuration when scanning netdevices (#290647)
* Fixed an issue where data sources of deleted inventoried endpoints were shown as an option in the table filter on the registered endpoints page (#290584)
* Fixed an issue which prevented Netdevices from correctly being written to CSV import files in scheduled scripts which are using the "netdevice" import type (#290147)
* Fixed an issue with properly updating the table ID sequence when restoring a backup. (#290662)
* Fixed event log message MAC_IN_MULTIPLE_VLANS being logged unnecessarily. (#290519)
* Fixed some issues in data import event log messages (prevent nested messages, always show simple filename without path) (#290610)
* Improved exception handling in connection event logger (#290649)
* In case no DNS servers for zone transfer are configured, don't show a warning (WARN_DNS_IMPORT_FAILED) in the log file. (#290406)
* In case of an invalid uplink regex configuration, log error and continue, instead of crashing the entire netdevice scanner task. (#290646)
* Profiler default datasets are only imported when really needed (license module enabled and table empty) (#289969)
* When configuring a network interface statically via console, set default gateway and DNS servers to static as well, if they have been previously configured to use DHCP. (#289789)
* Whitespace is now removed from interface alias when scanning switches and storing switch interface information into the database. This should prevent certain issues with uplink detection from port tags. (#290587)

### Documentation

* Added USP NAS Quick Setup Guide (#290511)
* Added list of known compatible network equipment vendors and models to documentation (#289957)
* The USP NAS Migration guide, which describes how to handle potentially breaking changes during major upgrades, can now be accessed from the NAS WebGUI (#290171)

