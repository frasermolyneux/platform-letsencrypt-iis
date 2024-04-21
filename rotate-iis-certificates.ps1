param(
    [String]$cloudflareApiKey
)

Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

$secureCloudflareApiKey = ConvertTo-SecureString -String $cloudflareApiKey -AsPlainText -Force
$pArgs = @{CFToken = $secureCloudflareApiKey }

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
Import-Module WebAdministration

# Use Lets Encrypt Staging environment
Set-PAServer LE_STAGE

# Loop through all IIS sites and obtain certificates from Lets Encrypt
Get-Website | ForEach-Object {
    $site = $_

    # Get all bindings for the site
    $bindings = Get-WebBinding -Name $site.name

    # Filter out bindings that are not HTTPS
    $bindings = $bindings | Where-Object { $_.protocol -eq 'https' }

    # Loop through all bindings
    $bindings | ForEach-Object {
        $binding = $_

        $port, $hostHeader = $binding.bindingInformation.split(':')[1..2]

        Write-Host "Obtaining certificate for binding: '$hostHeader'"
        New-PACertificate $hostHeader -AcceptTOS -Contact "admin@molyneux.io" -Plugin Cloudflare -PluginArgs $pArgs -Install -Verbose
    }
}
