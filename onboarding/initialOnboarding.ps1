### !!! THIS SCRIPT IS A WORK-IN-PROGRESS !!!
### Don't run this script all at once!!!

### This file contains mutliple commands that can be used  to speed-up the
### process of onboarding a new computer.
### Working as of: 2025-12-08

# Allows custom PS scripts to be run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Installs latest Windows Updates. Double-check the Settings app to be sure
Install-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate

# Enable "Windows Features" - Always double-check

# "SMB 1.0/CIFS File Sharing Support"
Enable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -All -NoRestart
# ".NET Framework 3.5 (includes .NET 2.0 and 3.0)"
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart
