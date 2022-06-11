function New-VM {
    try {
        Import-Module VMware.VimAutomation.Core | Out-Null
    }
    catch {
        Write-Output "Remove-Snaps failed on uspp-iaasauto01"
    }
    # Add create VM function
}