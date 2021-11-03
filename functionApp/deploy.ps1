## Place Resource Group Name here
$rgName = "flkelly-bicep-neu1"
## add tags if you want to add metadata
$tags = @{"deploymentMethod"="bicep"; "Can Be Deleted"="yes"}
## location to be deployed into
$rgLocation = "northeurope"

#use this command when you need to create a new resource group for your deployment
$rg = New-AzResourceGroup -Name $rgName -Location $rgLocation 
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

$bicepFile = ".\functionApp.bicep"

az bicep build --file $bicepFile
$jsonFile = '.' + $bicepFile.Split('.')[1] + '.json'

$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
#New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -name $deploymentName
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $jsonFile -name $deploymentName
