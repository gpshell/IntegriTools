<#
!!! THIS SCRIPT IS A WORK-IN-PROGRESS !!!
This script has only been tested on a few PCs, so its results
may not be useful in some circumstances. Always double check.
#>

### Returns information about displays connected to the PC.
### Working as of: 2025-12-17

#!ps
#maxlength=500000
#timeout=3000000
$connections = get-ciminstance -namespace root/wmi -classname WmiMonitorConnectionParams
$monitors = get-ciminstance -namespace root/wmi -classname WmiMonitorID

$data = @() #array to be populated with results

foreach ($con in $connections)
{
  $vot = "Unknown"
  $displayName = "Unknown"
  $instanceName = "Unknown"

  foreach ($mon in $monitors)
  {
    if ($mon.InstanceName -eq $con.InstanceName)
    {
      if ($con.VideoOutputTechnology -eq 0) { $vot = "VGA" }
      elseif ($con.VideoOutputTechnology -eq 4) { $vot = "DVI" }
      elseif ($con.VideoOutputTechnology -eq 5) { $vot = "HDMI" }
      elseif ($con.VideoOutputTechnology -eq 10) { $vot = "DP (External)" }
      elseif ($con.VideoOutputTechnology -eq 11) { $vot = "DP (Embeded)" }
      elseif ($con.VideoOutputTechnology -eq 2147483648) { $vot = "Internal" }

      if ($mon.UserFriendlyName)
      {
        $displayName = [System.Text.Encoding]::ASCII.GetString($mon.UserFriendlyName)
      }
      elseif ($mon.ManufacturerName)
      {
        $displayName = [System.Text.Encoding]::ASCII.GetString($mon.ManufacturerName)
      }
      if ($mon.InstanceName)
      {
        $instanceName = $con.InstanceName
      }
    }
  }
  $data += [PSCustomObject]@{
    ConnectionType = $vot;
    DisplayName = $displayName;
    InstanceName = $instanceName
  }
}

$data | Format-List

<#
Results are displayed as a list with 3 fields per item:
ConnectionType - Only applicable to the PC, not the monitor. (E.g. a DP-to-HDMI cable will show up as DP, as the DP is connected to the PC)
DisplayName - Name of the monitor; if no name is found, the script tries to display the manufacturer name (e.g. LEN = LENOVO)
InstanceName - A unique value used to differentiate between monitors. 2 identical monitors will have different instance names
#>

<# Key (DEV USE ONLY; NOT NEEDED TO RUN THE SCRIPT)
typedef enum _D3DKMDT_VIDEO_OUTPUT_TECHNOLOGY {
  D3DKMDT_VOT_UNINITIALIZED = -2,
  D3DKMDT_VOT_OTHER = -1,
  D3DKMDT_VOT_HD15 = 0,
  D3DKMDT_VOT_SVIDEO = 1,
  D3DKMDT_VOT_COMPOSITE_VIDEO = 2,
  D3DKMDT_VOT_COMPONENT_VIDEO = 3,
  D3DKMDT_VOT_DVI = 4,
  D3DKMDT_VOT_HDMI = 5,
  D3DKMDT_VOT_LVDS = 6,
  D3DKMDT_VOT_D_JPN = 8,
  D3DKMDT_VOT_SDI = 9,
  D3DKMDT_VOT_DISPLAYPORT_EXTERNAL = 10,
  D3DKMDT_VOT_DISPLAYPORT_EMBEDDED = 11,
  D3DKMDT_VOT_UDI_EXTERNAL = 12,
  D3DKMDT_VOT_UDI_EMBEDDED = 13,
  D3DKMDT_VOT_SDTVDONGLE = 14,
  D3DKMDT_VOT_MIRACAST = 15,
  D3DKMDT_VOT_INDIRECT_WIRED = 16,
  D3DKMDT_VOT_INTERNAL = 0x80000000,
  D3DKMDT_VOT_SVIDEO_4PIN = D3DKMDT_VOT_SVIDEO,
  D3DKMDT_VOT_SVIDEO_7PIN = D3DKMDT_VOT_SVIDEO,
  D3DKMDT_VOT_RF = D3DKMDT_VOT_COMPOSITE_VIDEO,
  D3DKMDT_VOT_RCA_3COMPONENT = D3DKMDT_VOT_COMPOSITE_VIDEO,
  D3DKMDT_VOT_BNC = D3DKMDT_VOT_COMPOSITE_VIDEO
} D3DKMDT_VIDEO_OUTPUT_TECHNOLOGY;
#>