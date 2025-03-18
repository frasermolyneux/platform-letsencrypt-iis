param(
    [String]$cloudflareApiKey
)

Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$secureCloudflareApiKey = ConvertTo-SecureString -String $cloudflareApiKey -AsPlainText -Force
$pArgs = @{CFToken = $secureCloudflareApiKey }

# Install and import required modules
Get-PSRepository | Write-Host
Find-Module -Name Posh-ACME | Install-Module -Scope CurrentUser -Confirm:$False -Force

# Configure Posh-ACME
$env:POSHACME_HOME = 'C:\ACME'
if (-not (Test-Path $env:POSHACME_HOME)) {
    New-Item -ItemType Directory -Path $env:POSHACME_HOME
}

# Import required modules
Import-Module Posh-ACME
Import-Module WebAdministration

# Load local functions
Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 | ForEach-Object { . $_.FullName }

# Set Lets Encrypt environment
Set-PAServer LE_PROD #LE_STAGE

# Loop through all IIS sites and obtain certificates from Lets Encrypt
Get-Website | ForEach-Object {
    $site = $_

    # Get all bindings for the site
    $bindings = Get-WebBinding -Name $site.name -Protocol "https"

    # Loop through all bindings
    $bindings | ForEach-Object {
        $binding = $_

        $ipAddress, $port, $hostHeader = $binding.bindingInformation.split(':')[0..2]

        Write-Host "Obtaining certificate for binding: '$hostHeader'"
        New-PACertificate $hostHeader -AcceptTOS -Contact "frasermolyneux@mx-mail.io" -Plugin Cloudflare -PluginArgs $pArgs -Verbose -Force

        # Renew the certificate if required
        Submit-Renewal $hostHeader -Verbose

        # Retrieve the latest certificate (either from New-PACetificate or Submit-Renewal)
        $latestCertificate = Get-PACertificate $hostHeader

        # Update the binding with the new certificate
        Write-Host "Updating binding with new certificate for site '$($site.name)' with host '$hostHeader' on port $port"
        $latestCertificate | Set-IISCertificate -SiteName $site.name -IPAddress $ipAddress -Port $port -HostHeader $hostHeader -RemoveOldCert -RequireSNI
    }
}
