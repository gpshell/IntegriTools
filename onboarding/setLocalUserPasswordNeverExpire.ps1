### Makes it so a local user's password never expires
### Working as of: 2026-01-13

Set-LocalUser -Name 'ExampleUserName' -PasswordNeverExpires $true