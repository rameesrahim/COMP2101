function get-net{
    $net = get-ciminstance Win32_NetworkAdapterConfiguration | where IPenabled -eq True | ft -Autosize -Wrap Index, IPSubnet, DNSDomain, DNSServerSearchOrder, Description, IPAddress
   
    $net
}
get-net