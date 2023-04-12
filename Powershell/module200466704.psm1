fnction welcome{
    write-output "Welcome to planet $env:computername Overlord $env:username"
    $now = get-date -format 'HH:MM tt on dddd'
    write-output "It is $now."
}

function get-System{
    Write-Output "System Description"
    Write-Output "=================="
    $data = get-ciminstance win32_computersystem | select Description 
    $data.PSObject.Properties | 
        foreach {
            if ($_.Value -eq $null) {$data.($_.Name) = "N/A";} 
        }
    $data | format-list
}

function get-OS{
    Write-Output "Operating System"
    Write-Output "================"
    $data = get-ciminstance win32_operatingsystem| select Version, Name
    $data.PSObject.Properties | 
        foreach {
            if ($_.Value -eq $null) {$data.($_.Name) = "N/A";} 
        }
    $data   | format-list
}


function get-cpuinfo{
    Write-Output "CPU Info"
    Write-Output "====================="
    $data = get-ciminstance win32_processor | select Description, CurrentClockSpeed, L1CacheSize, L2CacheSize, L3CacheSize
    $data.PSObject.Properties | 
        foreach {
            if ($_.Value -eq $null) {$data.($_.Name) = "N/A";} 
        }
    $data | format-list
}


function get-ram{
    Write-Output "System Memory"
    Write-Output "=============="
    $ram = get-ciminstance win32_physicalmemory | select Manufacturer, Description, Capacity , BankLabel, DeviceLocator
    $total = 0
    foreach( $slot in $ram){
        $slot.PSObject.Properties | 
        foreach {
            if ($_.Value -eq $null) {$slot.($_.Name) = "N/A";} 
        }
        $slot.Capacity = $slot.Capacity / 1gb
        $total += $slot.Capacity
    }
    $ram | format-table
    Write-Output "Total(GB): `t $total"
    Write-Output ""
}


function get-mydisks{
    Write-Output "Disks Info"
    Write-Output "================="
    $diskdrives = Get-CIMInstance CIM_diskdrive

    foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }
  Write-Output ""
}


function get-net{
    Write-Output "Network Information"
    Write-Output "==================="
    $net = get-ciminstance Win32_NetworkAdapterConfiguration | where IPenabled -eq True | ft -Autosize -Wrap Index, IPSubnet, DNSDomain, DNSServerSearchOrder, Description, IPAddress
    $net.PSObject.Properties | 
        foreach {
            if ($_.Value -eq $null) {$net.($_.Name) = "N/A";} 
        }
    $net | format-table
}


function get-Video{
    Write-Output "Video Card"
    Write-Output "======================"
    $video = get-ciminstance Win32_VideoController | select Name, Description, CurrentHorizontalResolution, CurrentVerticalResolution
    $details = new-object -typename psobject -property @{Vendor=$video.Name
                                               Description=$video.Description
                                               CurrentScreenResolution="$($video.CurrentHorizontalResolution) X $($video.CurrentVerticalResolution)"
                                            } 
    $details.PSObject.Properties | 
        foreach {
            if ($_.Value -eq $null) {$details.($_.Name) = "N/A";} 
        }
    $details | format-list
}
