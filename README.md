# Deleting User Data From C:

---

## Running the below code can clear up hard drive space from user data.

This can be used to clear up computers on various networks from the top level of administration spanning to multiple computers to a single use machine. The code will remove users after 30 days from there last log in.

This will have to be used in powershell in Administrator Mode! **IMPORTANT**

Input folder names in the quotations below followed by a comma to add multiple files you wish to exclude

### Define the list of users to exclude from deletion
`$ExcludedUsers = @("Admin", "service_account") # Add usernames you want to exclude here`

### Define the number of inactive days (parameterize this for flexibility)
`$InactiveDays = 30`

### Fetch user profiles that are not special, not loaded, and haven't been used in the specified number of days
`$LocalProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object {
    (!$_.Special) -and (!$_.Loaded) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-$InactiveDays))
}`

### Loop through the profiles and remove them if they are not in the exclusion list
`foreach ($LocalProfile in $LocalProfiles) {
    # Extract the username from the profile path (assumes profiles are under C:\Users)
    $Username = $LocalProfile.LocalPath.Replace("C:\Users\", "")

    # Check if the user is in the exclusion list
    if ($ExcludedUsers -notcontains $Username) {
        try {
            # Attempt to remove the user profile
            $LocalProfile | Remove-WmiObject
            Write-Host "Profile '$Username' deleted from path: $($LocalProfile.LocalPath)" -ForegroundColor DarkBlue
        }
        catch {
            # Log the error if profile deletion fails
            Write-Host "Failed to delete profile '$Username' at path: $($LocalProfile.LocalPath). Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Profile '$Username' is excluded and will not be deleted." -ForegroundColor Yellow
    }
}`

### Please feel free to use this code and tell me what you think it can always be improved.
