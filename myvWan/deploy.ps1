## Place Resource Group Name here
$rgName = "flkelly-vwan-deploy-1001"
## add tags if you want to add metadata
$tags = @{"deploymentMethod"="bicep"; "Can Be Deleted"="yes"}
## location to be deployed into
$rgLocation = "northeurope"

#use this command when you need to create a new resource group for your deployment
$rg = New-AzResourceGroup -Name $rgName -Location $rgLocation 
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

## bicep Deployment
## Bicep File name
$bicepFile = ".\main.bicep"

$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -name $deploymentName
