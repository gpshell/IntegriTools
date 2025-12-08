### Iterates over every distribution list in the tenancy and removes the user
### Working as of: 2025-12-08

$userEmail = "example@domain.com"

# Get distribution groups for the user
$distributionGroups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember $_.identity).PrimarySmtpAddress -contains $userEmail }

# Remove the user from each group
foreach ($group in $distributionGroups) {
    Remove-DistributionGroupMember -Identity $group.Identity -Member $userEmail -Confirm:$false

    Write-Host "Removed $userEmail from $($group.Name)"
}