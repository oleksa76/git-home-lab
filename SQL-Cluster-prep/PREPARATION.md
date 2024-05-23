## Preparetion
### Prepare host os
- 1 Remove unecessay software
- 2 Install Hyper-V
```ps
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```
- 3 Create image for windows server with GUI
```ps
$imagePath = "C:\Temp\SERVER_EVAL_x64FRE_en-us.iso"
$vhdPath = (Get-VMHost).VirtualHardDiskPath
$newVHD = New-VHD -SizeBytes 70GB -Dynamic -Path ($vhdPath+"\MASTER2022GUI-sys.vhdx")
$newVM = New-VM -Name "MASTER2022GUI" -MemoryStartupBytes 4000MB -Generation 2 -VHDPath $newVHD.Path -BootDevice VHD 
$newVM | Add-VMDvdDrive -Path $imagePath
$newVM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "Internal" 
$newVM | Set-VMMemory -DynamicMemoryEnabled  $true 
$newVM | Set-VMProcessor -count 2

$vmfw = $newVM | Get-VMFirmware
$hdd = $vmfw.BootOrder[0]
$pxe = $vmfw.BootOrder[1]
$dvd = $vmfw.BootOrder[2]
$newVM | Set-VMFirmware -BootOrder $dvd,$hdd,$pxe
```
- 4 Create image for windows core
- 5 Clone VMs
### Prepare template for MS SQL Cluster
Install SQL binaries for template
```cmd
Setup.exe /q /ACTION=PrepareImage l /FEATURES=SQLEngine /InstanceID =<MYINST> /IACCEPTSQLSERVERLICENSETERMS
```
/InstanceID - is used to identify installation on SQL binaries.

## Test the image
Setup testing environment.
### Domain controller
```ps
#Check package
Get-WindowsFeature AD-Domain-Services 
#Install package
Get-WindowsFeature AD-Domain-Services | Install-WindowsFeature 
#Promote to domain controller
Install-addsForest -DomainName "lab.local" -InstallDns
```

