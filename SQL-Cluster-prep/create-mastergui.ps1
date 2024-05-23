#Creating master image
#Deploy MASTER2022GUI
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