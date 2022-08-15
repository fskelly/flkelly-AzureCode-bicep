## location to be deployed into
$deploymentLocation = "northeurope"

## bicep Deployment
## Bicep File name
$bicepFile = ".\main.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
#New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $deploymentLocation -Name $deploymentName
New-AzDeployment -name $deploymentName -location $deploymentLocation -templateFile $bicepFile

##deploy HCX after the fact
$hcxBicepFile = ".\Modules\AVSAddons\HCX.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-hcx-deployment"
#New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $deploymentLocation -Name $deploymentName
New-AzDeployment -name $deploymentName -location $deploymentLocation -templateFile $hcxBicepFile 