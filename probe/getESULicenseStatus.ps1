### Checks if the current machine has a license applied for
### Windows 10 Extended Security Updates (ESU).
### Working as of: 2026-01-05

<#
Windows 10 ESU licenses come in 3 flavors: Year 1, Year 2, Year 3

Year 1: f520e45e-7413-4a34-a497-d2765967d094
Year 2: 1043add5-23b1-4afb-9a0f-64343c8f3f8d
Year 3: 83d49986-add3-41d7-ba33-87c7bfb5c0fb

Use the command below to check the status of a given license. 
It is currently set to check for the Year 1 license.
#>

cscript //NoLogo C:\Windows\System32\slmgr.vbs /dlv f520e45e-7413-4a34-a497-d2765967d094