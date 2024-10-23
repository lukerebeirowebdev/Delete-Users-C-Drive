# Define the list of users to exclude from deletion
$ExcludedUsers = @("Admin", "service_account") # Add usernames you want to exclude here

# Define the number of inactive days (parameterize this for flexibility)
$InactiveDays = 30

# Fetch user profiles that are not special, not loaded, and haven't been used in the specified number of days
$LocalProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object {
    (!$_.Special) -and (!$_.Loaded) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-$InactiveDays))
}

# Loop through the profiles and remove them if they are not in the exclusion list
foreach ($LocalProfile in $LocalProfiles) {
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
}
