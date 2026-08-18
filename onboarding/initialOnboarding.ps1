### !!! THIS SCRIPT IS A WORK-IN-PROGRESS !!!
### Don't run this script all at once!!!

### This file contains mutliple commands that can be used  to speed-up the
### process of onboarding a new computer.
### Working as of: 2025-12-08

# Allows custom PS scripts to be run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine


Install-Module PSWindowsUpdate

# If there is a problematic Windows update you wish to ignore, use the following command
# KB5074109 is being used as an example, but this can be replaced with another code
# Hide-WindowsUpdate -KBArticleID KB5074109 -Verbose

# Install latest Windows updates. Double-check the Settings app to be sure
Get-WindowsUpdate
Install-WindowsUpdate

## Enable "Windows Features" - Always double-check after

# "SMB 1.0/CIFS File Sharing Support"
Enable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -All -NoRestart
# ".NET Framework 3.5 (includes .NET 2.0 and 3.0)"
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart

# Taskbar - Hide Task View button (current user only)
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name 'ShowTaskViewButton' -Type 'DWord' -Value 0