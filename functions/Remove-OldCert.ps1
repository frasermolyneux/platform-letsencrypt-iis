function Remove-OldCert {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [string]$OldCertThumb,
        [ValidateSet('LocalMachine', 'CurrentUser')]
        [string]$StoreLocation = 'LocalMachine',
        [string]$StoreName = 'My'
    )

    if ($null -eq $OldCertThumb) { return }

    Get-ChildItem Cert:\$StoreLocation\$StoreName |
    Where-Object {
        $_.Thumbprint -eq $OldCertThumb
    } |
    ForEach-Object {
        Write-Verbose "Deleting old cert with thumbprint $OldCertThumb"
        $target = "Cert:\$StoreLocation\$StoreName\$($_.Thumbprint)"
        if ($PSCmdlet.ShouldProcess($target, 'Remove certificate')) {
            $_ | Remove-Item
        }
    }

}