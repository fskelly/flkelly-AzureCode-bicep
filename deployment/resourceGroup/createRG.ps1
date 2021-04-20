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
        'southcentralus' {''; break}
        'westus2' {''; break}
        'australiaeast' {''; break}
        'southeastasia' {''; break}
        'northeurope' {''; break}
        'uksouth' {''; break}
        'westeurope' {''; break}
        'centralus' {''; break}
        'northcentralus' {''; break}
        'westus' {''; break}
        'southafricanorth' {''; break}
        'centralindia' {''; break}
        'eastasia' {''; break}
        'japaneast' {''; break}
        'jioindiawest' {''; break}
        'koreacentral' {''; break}
        'canadacentral' {''; break}
        'francecentral' {''; break}
        'germanywestcentral' {''; break}
        'norwayeast' {''; break}
        'switzerlandnorth' {''; break}
        'uaenorth' {''; break}
        'brazilsouth' {''; break}
        'centraluseuap' {''; break}
        'westus3' {''; break}
        'southafricawest' {''; break}
        'australiacentral' {''; break}
        'australiacentral2' {''; break}
        'australiasoutheast' {''; break}
        'japanwest' {''; break}
        'koreasouth' {''; break}
        'southindia' {''; break}
        'westindia' {''; break}
        'canadaeast' {''; break}
        'francesouth' {''; break}
        'germanynorth' {''; break}
        'norwaywest' {''; break}
        'switzerlandwest' {''; break}
        'ukwest' {''; break}
        'uaecentral' {''; break}
        'brazilsoutheast' {''; break}
        Default { $regionName }
    }

    return $shortName;
}


$regions=$(az account list-locations --query "[?not_null(metadata.latitude)] .{RegionName:name}" --output json)

[int]$regionCount = ($regions | ConvertFrom-Json).count
$regions = ($regions | ConvertFrom-Json)
Write-Host "Found" $regionCount "regions"
$i = 0
foreach ($region in $regions)
{
  $sregionValue = $i
  Write-Host $sregionValue ":" $region.regionName
  $i++
}
Do 
{
  [int]$regionChoice = read-host -prompt "Select number & press enter"
} 
until ($regionChoice -le $regionCount)

Write-Host "You selected" $regions[$regionChoice].regionName

Get-RegionShortName $regions[$regionChoice].regionName

Write-Host ""