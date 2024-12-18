## resource group name to be created
## location to be deployed into
$rgLocation = read-host "Enter the location for the resource group."
$rgName = read-host "Enter the name of the resource group to be created."

## tenant id ofr Keyvault and object id
Get-AzTenant
$tenantID = read-host "Please enter your tenant ID - 'get-aztenant' can help here"
$objectID = read-host "Please enter the Object ID - can be gotten from Azure AD"

## add tags if you want to add metadata
$tags = @{"Purpose"="Security"; "Can Be Deleted"="no"}
#use this command when you need to create a new resource group for your deployment

$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

if (-not $rg) {
    # Resource group does not exist, create it using a Bicep module
    $deploymentLocation = "westeurope"
    Write-Output "Resource group $rgName does not exist. Creating it..."
    $deploymentName = "RGDeploy" +(get-date -Format ddMMyyyyhhmmss) + "deployment"
    New-AzSubscriptionDeployment -Location $deploymentLocation -TemplateFile ./enhanced/resourceGroups/rg.bicep -rgName $rgName -rgLocation $rgLocation -deploymentName $deploymentName
    #az deployment sub create --location $deploymentLocation --name $deploymentName --template-file ./enhanced/resourceGroups/rg.bicep --parameters rgName=$rgName rgLocation=$rgLocation
} else {
    Write-Output "Resource group $rgName already exists. Continuing..."
}

## Bicep File name
$bicepFile = ".\main.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"
New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -DeploymentName $deploymentName -tenant $tenantID -objectID $objectID -verbose