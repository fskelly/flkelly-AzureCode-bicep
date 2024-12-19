function Get-YesNoChoice {
    param (
        [string]$Prompt
    )

    while ($true) {
        $choice = Read-Host $Prompt
        switch ($choice.ToLower()) {
            'y' { return $true }
            'n' { return $false }
            default { Write-Host "Invalid choice. Please enter 'y' or 'n'." }
        }
    }
}

## this deploys without using the parameter files

# resource group variables
$rgName = read-host "Enter the name of the resource group to be created."
$rgLocation = read-host "Enter the location for the resource group."

# storage account variables

# kv variables
$deployKV = Get-YesNoChoice "Do you want to deploy a Key Vault? (y/n)"
##$deployKV = $true
if ($deployKV) {
    $tenantID = read-host "Enter the tenant ID."
    $objectID = read-host "Enter the object ID."
} else {
    $tenantID = "1"
    $objectID = "1"
}

# adding configuration to exclude secrets
$deploySecrets = Get-YesNoChoice "Do you want to deploy secrets? (y/n)"
if (!$deploySecrets) {
    $userName = ConvertTo-SecureString -String "1" -AsPlainText -Force
    $userPassword = ConvertTo-SecureString -String "1" -AsPlainText -Force
}

$rg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

$deploymentLocation = "westeurope"
$bicepFile = ".\main.bicep"
$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"

if (-not $rg) {
    write-output "Resource group $rgName does not exist. Creating it now..."
    $rgBicepFile = "./resourceGroups/rg.bicep"
    $rgDeploymentName = "rg-deployment-" + (Get-Date -Format "yyyyMMddHHmmss")
    New-AzSubscriptionDeployment -TemplateFile $rgBicepFile -Location $deploymentLocation -Name $rgDeploymentName -rgName $rgName -rgLocation $rgLocation #-verbose
    Write-Output "Resource group $rgName created successfully."
    write-output "Deploying the main template now..."
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -tenant $tenantID -objectID $objectID -deployKV $deployKV -deploySecrets $deploySecrets -userPassword $userPassword -userName $userName #-verbose
} elseif ($rg.Location -ne $rgLocation) {
    Write-Output "Resource group $rgName exists in a different location ($($rg.Location)). Please use the correct location."
    exit 1
} else {
    Write-Output "Resource group $rgName already exists in the correct location. Continuing..."
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile $bicepFile -Name $deploymentName -rgName $rgName -rgLocation $rgLocation -tenant $tenantID -objectID $objectID -deployKV $deployKV -deploySecrets $deploySecrets  -userPassword $userPassword -userName $userName #-verbose
}