### !!! THIS SCRIPT IS A WORK-IN-PROGRESS !!!
### Tries to identify which monitor cables are connected to the PC.
### Working as of: 2025-12-08

$connections = get-ciminstance -namespace root/wmi -classname WmiMonitorConnectionParams

foreach ($con in $connections)
{

    if ($con.videooutputtechnology -eq 0) {write-host "VGA - $($con.InstanceName)" -ForegroundColor Red}
    elseif ($con.videooutputtechnology -eq 10) {write-host "DP - $($con.InstanceName)" -ForegroundColor Red}
    elseif ($con.videooutputtechnology -eq 4) {write-host "DVI - $($con.InstanceName)" -ForegroundColor Red}
    elseif ($con.videooutputtechnology -eq 5) {write-host "HDMI - $($con.InstanceName)" -ForegroundColor Red}
    else {write-host "$($con.videooutputtechnology) is unknown" -ForegroundColor Red}
}


<# Key
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