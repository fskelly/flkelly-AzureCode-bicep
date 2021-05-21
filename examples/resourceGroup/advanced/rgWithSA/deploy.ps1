## location to be deployed into
$rgLocation = "westeurope"

## bicep Deployment
## Bicep File name
$bicepFile = ".\main.bicep"
New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $rgLocation
