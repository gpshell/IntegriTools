###  FOR ALL USERS: Sets the AutoReply message to "" for internal and external; Sets AutoReply to disabled
### Working as of: 2025-12-08

Get-Mailbox -RecipientType UserMailbox | Set-MailboxAutoReplyConfiguration -AutoReplyState disabled -ExternalAudience all -InternalMessage "" -ExternalMessage ""

# If you want to omit certain users (e.g. affect all users except ExampleUser1 and ExampleUser2), use Where-Object like so:

# Get-Mailbox -RecipientType UserMailbox | Where-Object { $_.Alias -ne "ExampleUser1" -and $_.Alias -ne "ExampleUser2" } | Set-MailboxAutoReplyConfiguration -AutoReplyState disabled -ExternalAudience all -InternalMessage "" -ExternalMessage ""

# For a list of user aliases, use the following:
# Get-Mailbox -RecipientType UserMailbox