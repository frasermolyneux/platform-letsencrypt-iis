
Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

# Load the configuration
. $PSScriptRoot\config.ps1

# Install and import required modules
Get-PSRepository | Write-Host
Find-Module -Name ACMESharp | Install-Module -Scope CurrentUser -AcceptLicense -Confirm:$False -Force
Import-Module ACMESharp

# Rotate certificates for required bindings
$bindings | ForEach-Object {
    $binding = $_

    Write-Host "Rotating certificate for domain: '$($binding.domain)'"
}