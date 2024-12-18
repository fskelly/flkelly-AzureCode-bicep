# resource group variables
$rgName = read-host "Enter the name of the resource group to be created."
$rgLocation = read-host "Enter the location for the resource group."

# storage account variables

# kv variables
#$deployKV = read-host "Do you want to deploy a Key Vault? (y/n)"
$deployKV = "N"
if ($deployKV -eq "y") {
    #$kvName = read-host "Enter the name of the Key Vault to be created."
    #$kvLocation = read-host "Enter the location for the Key Vault."
    #$kvSku = read-host "Enter the SKU for the Key Vault."
    #$kvAccessPolicy = read-host "Enter the object ID for the Key Vault access policy."
    $tenantID = read-host "Enter the tenant ID."
    $objectID = read-host "Enter the object ID."
}


$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

$deploymentLocation = "westeurope"
$bicepFile = ".\main.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"

$createRg = $false
if (-not $rg) {
    Write-Output "Setting createRG variable to TRUE."
    $createRg = $true
    #$deploymentName = "rg.bicep-deployment"
    #$deploymentLocation = "westeurope"
    #$bicepFile = ".\main.bicep"
    #New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $deploymentLocation -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -verbose
} elseif ($rg.Location -ne $rgLocation) {
    Write-Output "Resource group $rgName exists in a different location ($($rg.Location)). Please use the correct location."
    exit 1
} else {
    Write-Output "Resource group $rgName already exists in the correct location. Continuing..."
    #$bicepFile = ".\main.bicep"
    #$deploymentName = "main.bicep-deployment"
    #New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -DeploymentName $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -tenant $tenantID -objectID $objectID -verbose
}
if ($deployKV -eq "y") {
    New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $deploymentLocation -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -verbose -tenant $tenantID -objectID $objectID
} else {
    New-AzSubscriptionDeployment -TemplateFile $bicepFile -Location $deploymentLocation -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -verbose
}
