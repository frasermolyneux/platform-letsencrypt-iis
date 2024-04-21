param(
    [String]$cloudflareApiKey
)

Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

$secureCloudflareApiKey = ConvertTo-SecureString -String $cloudflareApiKey -AsPlainText -Force
$pArgs = @{CFToken = $secureCloudflareApiKey }

# Install and import required modules
Get-PSRepository | Write-Host
Find-Module -Name WebAdministration | Install-Module -Scope CurrentUser -AcceptLicense -Confirm:$False -Force
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
    $bindings = Get-WebBinding -Name $site.name -Protocol "https"

    # Loop through all bindings
    $bindings | ForEach-Object {
        $binding = $_

        $ipAddress, $port, $hostHeader = $binding.bindingInformation.split(':')[0..2]

        Write-Host "Obtaining certificate for binding: '$hostHeader'"
        New-PACertificate $hostHeader -AcceptTOS -Contact "admin@molyneux.io" -Plugin Cloudflare -PluginArgs $pArgs -Verbose

        # Renew the certificate if required
        Submit-Renewal $hostHeader -Verbose

        # Retrieve the latest certificate (either from New-PACetificate or Submit-Renewal)
        $latestCertificate = Get-PACertificate $hostHeader

        # Update the binding with the new certificate
        Write-Host "Updating binding with new certificate for site '$($site.name)' with host '$hostHeader' on port $port"
        $latestCertificate | Set-IISCertificate -SiteName $site.name -IPAddress $ipAddress -Port $port -HostHeader $hostHeader -RemoveOldCert -RequireSNI
    }
}
