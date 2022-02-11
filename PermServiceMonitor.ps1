$WMISub = @{

ComputerName = $env:COMPUTERNAME
ErrorAction = 'Stop'
NameSpace = 'root\subscription'

}

$WMISub.Class = '__EventFilter'
$WMISub.Arguments = @{
    EventNamespace = 'root\cimv2'
    Name = "EvilServiceDetectFilter"
    Query = "select * from __InstanceCreationEvent where TargetInstance ISA 'Win32_NTLogEvent' AND TargetInstance.EventCode=7045 AND TargetInstance.LogFile='System' AND (TargetInstance.Message LIKE '%powershell%' OR TargetInstance.Message LIKE '%comspec%' OR TargetInstance.Message LIKE '%ADMIN$%' OR TargetInstance.Message LIKE '%C$%' OR TargetInstance.Message LIKE '%screenconnect%' OR TargetInstance.Message LIKE '%psexesvc%' OR TargetInstance.Message LIKE '%cmd /c%' OR TargetInstance.Message LIKE '%cmd.exe /c%')"
    QueryLanguage = 'WQL'
}

$Filter = Set-WmiInstance @WMISub

$WMISub.Class = 'LogFileEventConsumer'
$WMISub.Arguments = @{
    Name = "EvilServiceDetectLog"
    Text = 'Evil Service Install Detected: Time: %TargetInstance.TimeGenerated% Computer: %TargetInstance.ComputerName% User: %TargetInstance.User% Message: %TargetInstance.Message%'
    FileName = 'c:\temp\servicedetect.log'
}

$Consumer = Set-WmiInstance @WMISub

$WMISub.Class = '__FilterToConsumerBinding'
$WMISub.Arguments = @{
Filter = $Filter
Consumer = $Consumer
}

$Binding = Set-WmiInstance @WMISub

$WMISub.Class = 'SMTPEventConsumer'
$WMISub.Arguments = @{
Name = 'EvilServiceDetectEmail'
ToLine = 'ENTERTOADDRESS'
ReplyToLine = 'ENTERREPLYADDRESS'
SMTPServer = 'ENTERSMTPADDRESS'
Subject = 'Evil Service Detected'
Message = 'Evil Service Install Detected: Time: %TargetInstance.TimeGenerated% Computer: %TargetInstance.ComputerName% User: %TargetInstance.User% Message: %TargetInstance.Message%'
}

$Consumer = Set-WmiInstance @WMISub

$WMISub.Class = '__FilterToConsumerBinding'
$WMISub.Arguments = @{
Filter = $Filter
Consumer = $Consumer
}

$Binding = Set-WmiInstance @WMISub


##Remove Subscriptions
#Get-WmiObject -namespace root\subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%EvilServiceDetectEmail%'"  | Remove-WmiObject
#Get-WmiObject -namespace root\subscription -Class __FilterToConsumerBinding -Filter "__Path LIKE '%EvilServiceDetectLog%'" | Remove-WmiObject
#Get-WmiObject -namespace root\subscription -Class SMTPEventConsumer -Filter "Name='EvilServiceDetectEmail'" | Remove-WmiObject
#Get-WmiObject -namespace root\subscription -Class LogFileEventConsumer -Filter "Name='EvilServiceDetectLog'" | Remove-WmiObject
#Get-WmiObject -namespace root\subscription -Class __EventFilter -Filter "Name='EvilServiceDetectFilter'" | Remove-WmiObject
