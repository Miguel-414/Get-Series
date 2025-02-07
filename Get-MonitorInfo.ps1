$monitores = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID

foreach ($monitor in $monitores) {
    $marca = [System.Text.Encoding]::ASCII.GetString($monitor.ManufacturerName) -replace '\x00',''
    $modelo = [System.Text.Encoding]::ASCII.GetString($monitor.UserFriendlyName) -replace '\x00',''
    $serial = [System.Text.Encoding]::ASCII.GetString($monitor.SerialNumberID) -replace '\x00',''
    
    Write-Output "Marca: $marca"
    Write-Output "Modelo: $modelo"
    Write-Output "Número de serie: $serial"
    Write-Output "------------------------------------"
}
