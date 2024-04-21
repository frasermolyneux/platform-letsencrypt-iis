param(
    [String]$cloudflareApiKey
)

Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

$secureCloudflareApiKey = ConvertTo-SecureString -String $cloudflareApiKey -AsPlainText -Force
$pArgs = @{CFToken = $secureCloudflareApiKey }

# Load the configuration
. $PSScriptRoot\config.ps1

# Install and import required modules
Get-PSRepository | Write-Host
Find-Module -Name Posh-ACME | Install-Module -Scope CurrentUser -AcceptLicense -Confirm:$False -Force
Find-Module -Name Posh-ACME.Deploy | Install-Module -Scope CurrentUser -AcceptLicense -Confirm:$False -Force

# Configure Posh-ACME
$env:POSHACME_HOME = 'C:\ACME'
if (-not (Test-Path $env:POSHACME_HOME)) {
    New-Item -ItemType Directory -Path $env:POSHACME_HOME
}

# Import required modules
Import-Module Posh-ACME
Import-Module Posh-ACME.Deploy

# Use Lets Encrypt Staging environment
Set-PAServer LE_STAGE

# Rotate certificates for required bindings
$bindings | ForEach-Object {
    $binding = $_

    Write-Host "Rotating certificate for domain: '$($binding.domain)'"
    New-PACertificate $binding.domain -AcceptTOS -Contact $adminEmail -Plugin Cloudflare -PluginArgs $pArgs
}