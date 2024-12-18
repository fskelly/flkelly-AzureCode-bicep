# resource group variables
$rgName = read-host "Enter the name of the resource group to be created."
$rgLocation = read-host "Enter the location for the resource group."

# storage account variables

# kv variables
#$deployKV = read-host "Do you want to deploy a Key Vault? (y/n)"
$deployKV = $true
if ($deployKV) {
    $tenantID = read-host "Enter the tenant ID."
    $objectID = read-host "Enter the object ID."
} else {
    $tenantID = "1"
    $objectID = "1"
}

$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

$deploymentLocation = "westeurope"
$bicepFile = ".\main.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"

$createRg = $false
if (-not $rg) {
    Write-Output "Setting createRG variable to TRUE."
    write-output "Resource group $rgName does not exist. Creating it now..."
    $createRg = $true
    $rgBicepFile = "./resourceGroups/rg.bicep"
    $rgDeploymentName = "rg-deployment-" + (Get-Date -Format "yyyyMMddHHmmss")
    New-AzSubscriptionDeployment -TemplateFile $rgBicepFile -Location $rgLocation -Name $rgDeploymentName -rgName $rgName -rgLocation $rgLocation -verbose
    Write-Output "Resource group $rgName created successfully."
    write-output "Deploying the main template now..."
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -tenant $tenantID -objectID $objectID -userName $userName -userPassword $userPassword -deployKV $deployKV -verbose
} elseif ($rg.Location -ne $rgLocation) {
    Write-Output "Resource group $rgName exists in a different location ($($rg.Location)). Please use the correct location."
    exit 1
} else {
    Write-Output "Resource group $rgName already exists in the correct location. Continuing..."
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -createRg $createRg -tenant $tenantID -objectID $objectID -userName $userName -userPassword $userPassword -deployKV $deployKV -verbose
}