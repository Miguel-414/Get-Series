# Función para decodificar los bytes a texto (eliminando caracteres nulos)
function Decode-MonitorData {
    param (
        [byte[]]$Bytes
    )
    if ($Bytes -eq $null -or $Bytes.Length -eq 0) {
        return "No disponible"
    }
    return [System.Text.Encoding]::ASCII.GetString($Bytes) -replace '\x00',''
}

# Obtener información de los monitores (usando WMI o CIM según la versión de PowerShell)
try {
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        # PowerShell Core (v6+)
        $monitores = Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorID -ErrorAction Stop
    } else {
        # Windows PowerShell (v5.1 o anterior)
        $monitores = Get-WmiObject -Namespace root/wmi -Class WmiMonitorID -ErrorAction Stop
    }

    if (-not $monitores) {
        Write-Output "No se detectaron monitores conectados."
        exit
    }

    # Procesar cada monitor
    foreach ($monitor in $monitores) {
        $marca    = Decode-MonitorData -Bytes $monitor.ManufacturerName
        $modelo   = Decode-MonitorData -Bytes $monitor.UserFriendlyName
        $serial   = Decode-MonitorData -Bytes $monitor.SerialNumberID

        Write-Output "=== Información del Monitor ==="
        Write-Output "Marca:    $marca"
        Write-Output "Modelo:   $modelo"
        Write-Output "Serial:   $serial"
        Write-Output "=============================="
        Write-Output ""
    }
} catch {
    Write-Output "Error al obtener información de los monitores: $_"
}