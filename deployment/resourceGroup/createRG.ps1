
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

##run queries to get data
$shortname, $region = Select-AzureRegion
$alias = "flkelly"
##$suffix = 1
$rgName = Get-ResourceGroupAvailability -alias $alias -region $region -shortname $shortname ##-startSuffix $suffix

Write-Header "Creating Resource Group - $rgName"

new-azresourcegroup -Name $rgName -Location $region