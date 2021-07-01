## Place Resource Group Name here
$rgName = ""
## add tags if you want to add metadata
$tags = @{"deploymentMethod"="bicep"; "Can Be Deleted"="yes"}
## location to be deployed into
$rgLocation = "westeurope"

#use this command when you need to create a new resource group for your deployment
$rg = New-AzResourceGroup -Name $rgName -Location $rgLocation 
New-AzTag -ResourceId $rg.ResourceId -Tag $tags

## arm file - for testing i use password
#New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile .\azureDeploy.json -authenticationType password

## bicep Deployment
## Bicep File name - SSH
$bicepFile = ".\ssh.bicep"

## Bicep File name - RDP
$bicepFile = ".\rdp.bicep"

## Bicep File name - Active Directory
$bicepFile = ".\adds.bicep"

$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -name $deploymentName
