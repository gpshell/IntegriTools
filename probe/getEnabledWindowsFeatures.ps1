### Checks if SMB 1.0/CIFS and .NET Framework 3.5 are enabled
### Working as of: 2025-12-08

Get-WindowsOptionalFeature -Online |
Where-Object { $_.State -eq 'Enabled' -and ($_.FeatureName -match 'SMB' -or $_.FeatureName -match 'NetFx') } |
Select-Object FeatureName, State
