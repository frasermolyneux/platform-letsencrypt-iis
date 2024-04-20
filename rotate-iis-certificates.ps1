
Write-Information "Rotating IIS certificates on $env:COMPUTERNAME"

# Load the configuration
. $PSScriptRoot\config.ps1

$bindings | ForEach-Object {
    $binding = $_

    Write-Information "Rotating certificate for domain: '$($binding.domain)'"
}