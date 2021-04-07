function New-ResourceGroup {
    param(
        [string] $resourceGroupName,
        [string] $region
    )

    $resourceGroupExists = (az group exists --name $resourceGroupName)
    if ($resourceGroupExists -eq $false) {
        Write-Log "Creating Resource Group $resourceGroupName"
        
        az group create -n $resourceGroupName -l $region
        Confirm-LastExitCode
    }
}

function Get-RegionShortName {
    param(
        [string] $regionName
    )

    $shortName = switch ($regionname) {
        'EastUS' { 'eus'; break }
        'EastUS2' { 'eus2'; break }
        'WestUS' { 'wus'; break }
        Default { $regionName }
    }

    return $shortName;
}

Write-Host ""