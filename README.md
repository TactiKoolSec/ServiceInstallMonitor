# ServiceInstallMonitor
One of the biggest ways that ransomware has changed the threat landscape is by significantly increasing the scope of potential targets for financially motivated adversaries. Prior to ransomware, the more advanced financially motivated adversaries targeted specific organizations that allowed them to monetize a compromise through point-of-sale systems or credit card theft. Ransomware has changed the focus so that every organization is a potential target and the adversaries have built the operations to monetize every successful compromise. On a positive note, the same operationalization of ransomware that has allowed the ransomware business to be so successful also leads to well-defined tactics, tools, and procedures that X-Force IR can continue to research and provide high effective controls and detections to better serve the defensive community. 
One of the most important detections of ransomware operator activity is within event id 7045 of the System event log. Ransomware adversaries commonly leverage the SCM within windows to create a new service to execute a payload to faciliate lateral movement or priv esc functions. 
The following PowerShell scripts, will monitor new events written to the System log and take action when specific conditions occur. The conditions defined within the WQL contain commonly used keywords associated with lateral movement and priv esc commands used by ransomware operators. 

This project includes two script files, PermServiceMonitor.ps1 and TempServiceMonitor.ps1

TempServiceMonitor creates a temporary WMI event subscription allowing users to easily modify the event filter and corrosponding actions. These subscription only remains for as long as the current powershell session. 
To configure, 
Line 14 specifies the log file location
Lines 23 - 25 specifies the SMTP settings for email alerts. 
Line 3 is where the WQL query is configured to target specific event log entries, this can be modified to tune matches as needed. 

Once the subscription has been tuned properly, users can implement it with PermServiceMonitor which creates a permanent WMI subscription which will persist outside of the powershell session and reboots. 
To configure,
Line 13 is where the WQL query is configured, recommend tuning with TempServiceMonitor monitor first.
Line 23 specified the log file location
Lines 39 - 41 specifies the SMTP settings for email alerts

Lines 58 - 62 can be executed to remove the permanent subscription

