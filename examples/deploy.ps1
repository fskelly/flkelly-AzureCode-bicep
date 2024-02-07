<#
.SYNOPSIS
Deploys Azure resources using Bicep.

.DESCRIPTION
This script deploys Azure resources using Bicep. It creates a new resource group if it doesn't exist and deploys the resources specified in the Bicep file.

.PARAMETER rgName
The name of the resource group to deploy the resources into.

.PARAMETER tags
Tags to add to the resource group.

.PARAMETER rgLocation
The location to deploy the resources into.

.PARAMETER bicepFile
The name of the Bicep file to deploy.

.EXAMPLE
.\deploy.ps1 -rgName "myResourceGroup" -tags @{"deploymentMethod"="bicep"; "Can Be Deleted"="yes"} -rgLocation "westeurope" -bicepFile "myBicepFile.bicep"

This example deploys the resources specified in the "myBicepFile.bicep" file into a new resource group named "myResourceGroup" in the "westeurope" location. It also adds the specified tags to the resource group.

.NOTES
This script requires the Az PowerShell module to be installed.
#>
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
## Bicep File name
$bicepFile = ""

$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -name $deploymentName
