### RDP fixes

# Enable RDP
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

# Enable Remote Desktop group on firewall
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes

# Add user to RDP group
net localgroup "remote desktop users" /add domain\user

# Returns '1' if RDP is not enabled
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections