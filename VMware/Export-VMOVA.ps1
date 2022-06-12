function Export-VMOVA {
    param (
        [Parameter(Mandatory = $true)] $VMname # Name of VM to be exported
    )

    try {
        Import-Module VMware.VimAutomation.Core | Out-Null
    }
    catch {
        Write-Output "Remove-Snaps failed on uspp-iaasauto01"
        exit
    }

    # Connects to vCenters
    try {
        $settings = Get-Content -Path "\%USERPROFILE%\Code\powershell\Configs\settings.json" | ConvertFrom-Json
        Connect-VIServer -Server $settings.vcServer -User $settings.vcUsername -Password $settings.vcPassword -WarningAction SilentlyContinue -Force -ErrorAction Stop -errorvariable ConVcenterError
    }
    catch {
        Write-Output "vCenter conection failed"
        exit
    }
    try {
        $selectedVM = Get-VM -Name $VMname
        $selectedVM | Remove-Snapshot -Removechildren -Confirm:$false -ErrorAction Stop
        $selectedVM | Shutdown-VMGuest -Confirm:$false -ErrorAction Stop
        $selectedVM | Get-CDDrive | Set-CDDrive -NoMedia -Confirm:$false -ErrorAction Stop
        Export-VM -VM $selectedVM -Destination "\%USERPROFILE%\Downloads" -Format Ova -Confirm:$false -ErrorAction Stop
    }
    catch {
        Write-Output "Export failed."
        Write-Output $error
        exit
    }
}
