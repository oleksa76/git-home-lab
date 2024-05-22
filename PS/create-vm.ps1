#$imagePath = "C:\Inst\14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO"
#$vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks"
$imagePath = "F:\Install\Win2019\WIN2019.iso"
$vhdPath = "D:\VHD"
$vmName = "SRV2019coreMASTER"
$newVHD = New-VHD -Path ($vhdPath+"\"+$vmName+".vhdx") -SizeBytes 50GB -Dynamic
$newVM = New-VM -Name $vmName -MemoryStartupBytes 2048MB -Generation 2 -VHDPath $newVHD.Path -BootDevice VHD
Start-Sleep 5
$newVM | Add-VMDvdDrive -Path $imagePath
$newVM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "Internet"
#$newVM | ADD-VMNetworkAdapter –Switchname "Internal"
$newVM | Set-VMMemory -DynamicMemoryEnabled  $true
$newVM | Set-VMProcessor –count 2

$vmfw = $newVM | Get-VMFirmware
$hdd = $vmfw.BootOrder[0]
$pxe = $vmfw.BootOrder[1]
$dvd = $vmfw.BootOrder[2]
$newVM | Set-VMFirmware -BootOrder $dvd,$hdd,$pxe
Start-Sleep 8
$newVM | Start-VM