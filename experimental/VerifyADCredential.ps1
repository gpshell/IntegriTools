### Opens a username/password entry field and returns "true" if the credentials are correct
### For best results, run this script on the domain controller
### Working as of: 2026-07-17
$creds=Get-Credential
Function Test-ADCreds {
    param($username, $password)
    (New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null
}
Test-ADCreds -username $creds.UserName -password $creds.GetNetworkCredential().password


<#
If the script returns "false", the possible causes are:
- Invalid username (check that the account exists on a domain) or password
- The user's account is disabled or locked in the AD
- The domain is not available

Original script: https://woshub.com/validate-ad-user-credentials-powershell/
#>