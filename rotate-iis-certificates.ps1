
Write-Host "Rotating IIS certificates on $env:COMPUTERNAME"

# Load the configuration
. $PSScriptRoot\config.ps1

$bindings | ForEach-Object {
    $binding = $_

    Write-Host "Rotating certificate for domain: '$($binding.domain)'"
}