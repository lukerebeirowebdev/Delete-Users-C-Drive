# Deleting User Data From C: 
---
Running the below code can clear up hard drive space from user data. 
--

This can be used to clear up computers on various networks from the top level of administration spanning to multiple computers to a single use machine. The code will remove users after 7 days from there last log in.

This will have to be used in powershell in Administrator Mode! **IMPORTANT**

`# Input folder names in the quotations below followed by a comma to add multiple files you wish to exclude

$ExcludedUsers =""
$LocalProfiles=Get-WMIObject -class Win32_UserProfile | Where-Object {(!$_.Special) -and (!$_.Loaded) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-7))}
foreach ($LocalProfile in $LocalProfiles)
{
if (!($ExcludedUsers -like $LocalProfile.LocalPath.Replace("C:\Users\","")))
{
$LocalProfile | Remove-WmiObject
Write-host $LocalProfile.LocalPath, "Profile Deleted” -ForegroundColor DarkBlue
}
}`

Please feel free to use this code and tell me what you think it can always be improved.


