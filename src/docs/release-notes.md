# USP Network Authentication System &reg; 15.0

Released 3 March 2025

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
* **New GUI:** Login with an LDAP-backed user is now possible via the modern GUI. (#289805)
* **New GUI:** The operating mode ("daemon mode") can be easily changed from the dashboard of the new GUI. A notification is shown in the sidebar if the mode is set to off. (#289662)
* Added an interface for scheduled jython scripts to send emails. See the related template for an example. (#290233)
* Added scheduled script template for netdevice import, demonstrating how entries can be generated which use SNMPv2 or SNMPv3 credentials (#290197)
* Hardware vendor name is now included in connection event (#289793)
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
* The menu entry "Core configuration" is now called "Application configuration" (#5688)
* Updated Angular UI framework to version 18 (#258137)
* Updated several third-party libraries to fix reported security vulnerabilities (CVE-2024-52317, CVE-2023-5072, CVE-2024-38821, CVE-2024-1597, CVE-2024-22243, CVE-2024-22259, CVE-2024-22262, CVE-2024-38809) (#290248)

### Bugfixes

* **New GUI**: Allow RADIUS authentication netdevices to be assigned to a portgropup, instead of switches only (#290373)
* **New GUI:** Fixed an issue where filter criteria info is lost on page refresh (#289853)
* Added check to import profiler default datasets only when needed (#289969)
* Fixed an issue where data sources of deleted inventoried endpoints where shown as an option in the table filter on the registered endpoints page (#290584)
* Fixed an issue which prevented Netdevices from correctly being written to CSV import files in scheduled scripts which are using the "netdevice" import type (#290147)
* Fixed event log message MAC_IN_MULTIPLE_VLANS being logged unnecessarily. (#290519)
* In case no DNS servers for zone transfer are configured, don't show a warning (WARN_DNS_IMPORT_FAILED) in the log file. (#290406)
* When configuring a network interface statically via console, set default gateway and DNS servers to static as well, if they have been previously configured to use DHCP. (#289789)
* Whitespace is now removed from interface alias when scanning switches and storing switch interface information into the database. This should prevent issues with uplink detection from port tags. (#290587)

### Documentation

* Added USP NAS Quick Setup Guide (#290511)
* The USP NAS Migration guide, which describes how to handle potentially breaking changes during major upgrades, can now be accessed from the NAS WebGUI (#290171)

