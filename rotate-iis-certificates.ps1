param(
    [securestring]$cloudflareApiKey
)

Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

# Load the configuration
. $PSScriptRoot\config.ps1

# Install and import required modules
Get-PSRepository | Write-Host
Find-Module -Name Posh-ACME | Install-Module -Scope CurrentUser -AcceptLicense -Confirm:$False -Force
Import-Module Posh-ACME

# Use Lets Encrypt Staging environment
Set-PAServer LE_STAGE

# Rotate certificates for required bindings
$bindings | ForEach-Object {
    $binding = $_

    Write-Host "Rotating certificate for domain: '$($binding.domain)'"
    $pArgs = @{CFToken = $apiKey }
    New-PACertificate $binding.domain -AcceptTOS -Contact $adminEmail -Plugin Cloudflare -PluginArgs $pArgs
}