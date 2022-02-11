$WMIEventFilter = ([wmiclass]"\\.\root\subscription:__EventFilter").CreateInstance()
$WMIEventFilter.QueryLanguage = "WQL"
$WMIEventFilter.Query = "select * from __InstanceCreationEvent where TargetInstance ISA 'Win32_NTLogEvent' AND TargetInstance.EventCode=7045 AND TargetInstance.LogFile='System' AND (TargetInstance.Message LIKE '%powershell%' OR TargetInstance.Message LIKE '%comspec%' OR TargetInstance.Message LIKE '%ADMIN$%' OR TargetInstance.Message LIKE '%C$%' OR TargetInstance.Message LIKE '%screenconnect%' OR TargetInstance.Message LIKE '%psexesvc%' OR TargetInstance.Message LIKE '%cmd /c%' OR TargetInstance.Message LIKE '%cmd.exe /c%')"
$WMIEventFilter.Name = "TempServiceMonFilter"
$WMIEventFilter.EventNamespace = 'root\cimv2'

$Output = $WMIEventFilter.Put()
$WMIFilter = $Output.Path

#Creating a new event consumer
$WMIConsumer = ([wmiclass]"\\.\root\subscription:LogFileEventConsumer").CreateInstance()

$WMIConsumer.Name = 'TempServiceMonConsumer'
$WMIConsumer.Filename = "C:\temp\Log.log"
$WMIConsumer.Text = 'Evil Service Install Detected: %TargetInstance.TimeGenerated% %TargetInstance.LogFile% %TargetInstance.User% %TargetInstance.Message%'

$Output = $WMIConsumer.Put()
$Consumer = $Output.Path

$WMIConsumer2 = ([wmiclass]"\\.\root\subscription:SMTPEventConsumer").CreateInstance()

$WMIConsumer2.Name = 'TempServiceMonConsumer2'
$WMIConsumer2.ToLine = 'ENTERTO'
$WMIConsumer2.ReplyToLine = 'ENTERREPLYTO'
$WMIConsumer2.SMTPServer = 'ENTERSMTPADDRESS'
$WMIConsumer2.Subject = 'Evil Service Detected'
$WMIConsumer2.Message = 'Evil Service Install Detected: %TargetInstance.TimeGenerated% %TargetInstance.ComputerName% %TargetInstance.LogFile% %TargetInstance.User% %TargetInstance.Message%'


$Output = $WMIConsumer2.Put()
$Consumer2 = $Output.Path

#Bind filter and consumer
$WMIBinding = ([wmiclass]"\\.\root\subscription:__FilterToConsumerBinding").CreateInstance()

$WMIBinding.Filter = $WMIFilter
$WMIBinding.Consumer = $Consumer
$Output = $WMIBinding.Put()
$Binding = $Output.Path

#Bind filter and consumer
$WMIBinding2 = ([wmiclass]"\\.\root\subscription:__FilterToConsumerBinding").CreateInstance()

$WMIBinding2.Filter = $WMIFilter
$WMIBinding2.Consumer = $Consumer2
$Output = $WMIBinding2.Put()
$Binding2 = $Output.Path

##Remove Subscriptions
#([wmi]$WMIFilter).Delete()
#([wmi]$Consumer).Delete()
#([wmi]$Binding).Delete()
#([wmi]$Consumer2).Delete()
#([wmi]$Binding2).Delete()