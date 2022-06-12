function Remove-Snaps {
    param (
        [Parameter(Mandatory = $true)] $NumOfDays # How many days old snaps can be before deletion, ex. if 90, any snaps older than 90 days will be removed
    )

    try {
        Import-Module VMware.VimAutomation.Core | Out-Null
    }
    catch {
        Write-Output "Remove-Snaps failed to run import PowerCLI module"
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

    # Get a list of VM then go through each and remove the latest snapshot and all children snapshots
    try {
        $snapshots = Get-VM -ErrorAction Stop | Get-Snapshot -ErrorAction Stop | Where-Object Created -lt (Get-Date).AddDays(-$NumOfDays) # Gets the current date then subtracts number of days from it
        if ($snapshots) {
            $snapshots | Remove-Snapshot -Removechildren -Confirm:$false -ErrorAction Stop
        }
    }
    catch {
        Write-Output "Snapshot removal Failed"
        exit
    }
}