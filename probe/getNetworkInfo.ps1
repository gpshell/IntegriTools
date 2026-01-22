### Returns network interfaces currently in-use
### Useful for determining if ethernet/wi-fi is on
### Working as of: 2026-01-22

#!ps
#maxlength=500000
#timeout=3000000
Get-NetConnectionProfile


### Returns all network interfaces
### Working as of: 2026-01-22

#!ps
#maxlength=500000
#timeout=3000000
Get-NetAdapter
