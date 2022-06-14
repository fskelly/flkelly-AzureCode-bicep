## Get key data
$publicKeyPath = ""
$sshKey = Get-Content $publicKeyPath
$secureSSHKey = ConvertTo-SecureString $sshKey -AsPlainText -Force

## Deploy to Azure
$resourceGroupName = ""
$resourceGroupLocation = ""
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./main.bicep -adminUsername "azureUser" -adminPasswordOrKey $secureSSHKey
