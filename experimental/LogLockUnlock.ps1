### Allows you to log whenever a user locks/unlocks a workstation
### Working as of: 2026-09-04

### DO THIS FIRST!!!
<#
WIN + R -> secpol.msc

Navigate to:

Advanced Audit Policy Configuration >
    System Audit Policies - Local Group Policy Object >
        Logon/Logoff >
            Audit Other Logon/Logoff Events


Go to properties and tick the box that says "Success"
#>


### Now you can use one of the following commands to query the user's lock/unlock (not retroactive)

# View locked times
wevtutil qe Security /q:"*[System[(EventID=4800)]]" /f:Text | findstr "Date"

# View unlocked times
wevtutil qe Security /q:"*[System[(EventID=4801)]]" /f:Text | findstr "Date"

# View both lock and unlock times
wevtutil qe Security /q:"*[System[(EventID=4800 or EventID=4801)]]" /f:Text | findstr "Date"


# Scripts and idea taken from: https://superuser.com/questions/1603205/how-to-get-the-timestamp-for-the-last-lock-unlock-of-windows-10-not-login-logo