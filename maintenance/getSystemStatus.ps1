### This script generates two CSV files. One containing system information, and one containing disk information
### This script is intended to be used during server maintenance, but should work on any Windows machine
### Working as of: 2025-12-08

Write-Host("System Status Report") -ForegroundColor Yellow

Write-Host("")

# Get the machine name , domain , and role within the domain
Write-Host("Domain Info") -BackgroundColor Blue
$roleMap = @{
    0 = "Standalone Workstation"
    1 = "Member Workstation"
    2 = "Standalone Server"
    3 = "Member Server"
    4 = "Backup Domain Controller"
    5 = "Primary Domain Controller"
}

$comp = Get-CimInstance Win32_ComputerSystem
$roleString = $roleMap[[int]$comp.DomainRole]

Write-Host "Computer Name : $($comp.Name)"
Write-Host "Domain        : $($comp.Domain)"
Write-Host "Domain Role   : $($roleString)"

Write-Host("")

# Get the OS
Write-Host("Operating System") -BackgroundColor Blue
#(Get-CimInstance Win32_OperatingSystem).Caption
$os = Get-CimInstance Win32_OperatingSystem

Write-Host "Operating System : $($os.Caption)"
Write-Host "Version          : $($os.Version)"
Write-Host "Build Number     : $($os.BuildNumber)"
Write-Host "Architecture     : $($os.OSArchitecture)"


Write-Host("")

# Get the average CPU usage over the last 5 seconds
Write-Host("CPU Info") -BackgroundColor Blue
$cpuName = (Get-CimInstance Win32_Processor).Name
Write-Host "Model: $($cpuName)"
Write-Host "Utilization: " -NoNewline
$cpuSamples = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 5
$averageCpu = ($cpuSamples.CounterSamples | Measure-Object -Property CookedValue -Average).Average
$avgCPU = "{0:N1}%" -f $averageCpu
Write-Host($($avgCPU))
$uptime = ((Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime).ToString("dd\.hh\:mm\:ss")
Write-Host("Uptime: $($uptime)")

Write-Host("")

# Get memory info

Write-Host("Memory Usage") -BackgroundColor Blue

$mem = Get-CimInstance -ClassName Win32_OperatingSystem

# Convert to GB and calculate usage
$totalRAM = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 1)  # Total RAM in GB
$freeRAM  = [math]::Round($mem.FreePhysicalMemory / 1MB, 1)      # Free RAM in GB
$usedRAM  = [math]::Round($totalRAM - $freeRAM, 1)                     # Used RAM in GB
$percentUsedRAM = [math]::Round(($usedRAM / $totalRAM) * 100, 1)       # Percent used
$maxAcceptableRamPercentage = 85
# Output nicely
Write-Host "Total RAM   : $totalRAM GB"
Write-Host "Used RAM    : $usedRAM GB"
Write-Host "Free RAM    : $freeRAM GB"
if ($percentUsedRAM -gt $maxAcceptableRamPercentage)
{
    Write-Host "Percent Used: " -NoNewline
    Write-Host "$percentUsedRAM%" -ForegroundColor Yellow
}
else 
{
    Write-Host "Percent Used: $percentUsedRAM%"
}

Write-Host("")
# Get the disk usage on all local disks (excludes network and removable drives)
Write-Host("Disk Usage") -BackgroundColor Blue
$diskUsage = Get-WmiObject -Class Win32_LogicalDisk | 
    Where-Object {$_. DriveType -eq 3} |
    Select-Object DeviceID,
            @{Name='Name'; Expression = {"$($_.VolumeName)"}},
            @{Name='Capacity'; Expression = {"$([math]::Round($_.Size /1GB, 1)) GB"}},
            @{Name='Remaining'; Expression = {"$([math]::Round($_.FreeSpace /1GB, 1)) GB"}},
            @{Name='% Free'; Expression = {
            if ($_.Size -ne 0) {
                "$([math]::Round(($_.FreeSpace / $_.Size) * 100, 1))%"
            } else {
                "N/A"
            }
        }}

$diskUsage | Format-Table -AutoSize

Write-Host("")
# Get the average ms to ping Google
Write-Host("Average Time to Ping 8.8.8.8") -BackgroundColor Blue
$ping = Test-Connection -ComputerName 8.8.8.8 -Count 5 -ErrorAction SilentlyContinue

if ($ping) {
    $avgPing = ($ping | Measure-Object -Property ResponseTime -Average).Average
    $avgPing = "{0:N1} ms" -f $avgPing
} else {
    $avgPing = "Unreachable"
}

Write-Host "Average Ping: $avgPing"

Write-Host("")


# Collect diagnostic data
$report = [PSCustomObject]@{
    "Computer Name"  = $comp.Name
    "Domain Name"    = $comp.Domain
    "Domain Role"    = $roleString
    " " = ""
    "OS"             = $os.Caption
    "OS Version"     = $os.Version
    "OS Build"       = $os.BuildNumber
    "OS Arcitecture" = $os.OSArchitecture
    "  "              = ""
    "CPU Model"      = $cpuName
    "CPU Usage"      = $avgCPU
    "Uptime"         = $uptime
    "   "              = ""
    "Total RAM (GB)" = $totalRAM
    "Used RAM (GB)"  = $usedRAM
    "Free RAM (GB)"  = $freeRAM
    "Used RAM (%)"   = $percentUsedRAM
    "    "              = ""
    "Avg. Ping (8.8.8.8)" = $avgPing
}

$verticalReport = $report.PSObject.Properties | ForEach-Object {
    [PSCustomObject]@{
        "Key" = $_.Name
        "Value"  = $_.Value
    }
}



# Export to CSV
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$verticalReport | Export-Csv -Path ".\$($comp.Name) $($timestamp).csv" -NoTypeInformation -Encoding UTF8

$diskUsage | Export-Csv -Path ".\DiskReport$($timestamp).csv" -NoTypeInformation -Encoding UTF8

Read-Host -Prompt "Press Enter to exit"