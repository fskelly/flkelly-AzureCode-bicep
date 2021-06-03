Write-Host "Please remember to login and connect first - you can use "Select-Subscription.ps1" to help with this"

## location to be deployed into
$rgLocation = "westeurope"

## bicep Deployment
## Bicep File name
$bicepFile = ".\main.bicep"
New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $rgLocation
