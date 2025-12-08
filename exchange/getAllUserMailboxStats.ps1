### Iterates over every user mailbox and prints the current size, capacity, and other information
### Useful for determining which mailboxes are nearly full
### Working as of: 2025-12-08

Get-Mailbox -ResultSize Unlimited | ForEach-Object {
    $mbx = $_
    $stats = Get-MailboxStatistics -Identity $mbx.Identity
    [PSCustomObject]@{
        DisplayName             = $mbx.DisplayName
        PrimarySMTPAddress      = $mbx.PrimarySmtpAddress
        TotalItemSize           = $stats.TotalItemSize
        ItemCount               = $stats.ItemCount
        IssueWarningQuota       = $mbx.IssueWarningQuota # the total capacity of the mailbox
    }
} | Sort-Object TotalItemSize -Descending | Format-Table -AutoSize