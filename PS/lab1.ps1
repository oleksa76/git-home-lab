#LAB 1 script
#$vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
$masterDEVHD = "F:\Install\MASTER_VHD\SRV2019DEMASTER.vhdx"
$vhdPath = "D:\VHD"
#create VM for router
$vmName = "GW01" #router GW01
$vmRouter = New-VM -Name $vmName -MemoryStartupBytes 2048MB -Generation 2
$vmRouter | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "Internet"
$vmRouter | ADD-VMNetworkAdapter –Switchname "Internal"
$vmRouter | Set-VMMemory -DynamicMemoryEnabled  $true
$vmRouter | Set-VMProcessor –count 2
Copy-Item $masterDEVHD -Destination ($vhdPath+"\"+$vmName+".vhdx")
$vmRouter | Add-VMHardDiskDrive -Path ($vhdPath+"\"+$vmName+".vhdx")

$vmfw = $vmRouter | Get-VMFirmware
$pxe1 = $vmRouter.BootOrder[0]
$pxe2 = $vmRouter.BootOrder[1]
$hdd =  $vmRouter.BootOrder[2]
$newVM | Set-VMFirmware -BootOrder $hdd,$pxe1,$pxe2
start-sleep 5
$vmRouter | Start-VM

