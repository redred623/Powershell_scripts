﻿$DD_group_list = Import-Csv -Path "**import group list**" 

$DD_Has_users = $DD_group_list |  ?{$_.count -ne 0} |select name,email

$date = (Get-Date).addDays(-1).ToString("MM-dd-yyyy")

$log = Get-MessageTrackingLog -ResultSize unlimited -Start "$date 00:00:00"  -End "$date 23:59:59"  -EventId Expand | `
 group-object -Property RelatedRecipientAddress -NoElement | select name,count |Sort-Object -Property Count -Descending
 
$log | Export-Csv "**export path**"

$no_traffic_dd = Compare-Object -ReferenceObject $DD_Has_users.email -DifferenceObject $log.name -IncludeEqual | ?{$_.sideindicator -eq '<='}

$no_traffic_dd | select @{name='Group Name'; expression={$_.inputobject}}| Export-Csv "**export path**"
