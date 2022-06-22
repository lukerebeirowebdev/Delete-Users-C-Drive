# Input folder names in the quotations below followed by a comma to add mutiple files you wish to exclude

$ExcludedUsers =""
$LocalProfiles=Get-WMIObject -class Win32_UserProfile | Where-Object {(!$_.Special) -and (!$_.Loaded) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-7))}
foreach ($LocalProfile in $LocalProfiles)
{
if (!($ExcludedUsers -like $LocalProfile.LocalPath.Replace("C:\Users\","")))
{
$LocalProfile | Remove-WmiObject
Write-host $LocalProfile.LocalPath, "Profile Deleted” -ForegroundColor DarkBlue
}
}