Write-Host "Please remember to login and connect first - you can use "Select-Subscription.ps1" to help with this"

## location to be deployed into
$deploymentLocation = "northeurope"

## bicep Deployment
## Bicep File name
$bicepFile = ".\main-2.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"

new-azdeployment -Name $deploymentName -TemplateFile $bicepFile -Location $deploymentLocation

## variables
#$rgName = "flkelly-neu-wan-rg"

## location to be deployed into
#$deploymentLocation = "northeurope"

#new-azresourcegroup -Name $rgName -Location $deploymentLocation

## bicep Deployment
## Bicep File name
#$bicepFile = ".\vnets.bicep"
#$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
#New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentName -TemplateFile $bicepFile