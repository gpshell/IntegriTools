### Returns a table of user mailboxes with an enabled AutoReplyConfiguration / Out-of-Office message . Currently 
### Working as of: 2025-12-08

Get-Mailbox -RecipientType UserMailbox | Get-MailboxAutoReplyConfiguration | Where-Object { $_.AutoReplyState -ne "Disabled" } | Select-Object Identity, StartTime, EndTime, AutoReplyState