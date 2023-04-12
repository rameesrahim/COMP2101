function get-mydisks{
    Get-CIMInstance CIM_diskdrive | select Manufacturer, Model, SerialNumber, FirmwareVersion, Size | ft
}