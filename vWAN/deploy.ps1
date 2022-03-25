## add tags if you want to add metadata
$tags = @{"deploymentMethod"="bicep"; "Can Be Deleted"="yes"}
$deploymentLocation = "northeurope"

## bicep Deployment
## Bicep File name
$bicepFile = ".\main.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
New-AzSubscriptionDeployment -Name $deploymentName -Location $deploymentLocation -Tag $tags -TemplateFile $bicepFile -location northeurope -vwanlocation northeurope