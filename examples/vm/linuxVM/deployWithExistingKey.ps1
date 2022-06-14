## Get key data
$publicKeyPath = ""
$sshKey = Get-Content $publicKeyPath
$secureSSHKey = ConvertTo-SecureString $sshKey -AsPlainText -Force

$privateKeyPath = ""

## Deploy to Azure
$resourceGroupName = ""
$resourceGroupLocation = ""
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./main.bicep -adminUsername "azureUser" -adminPasswordOrKey $secureSSHKey
$hostName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName).outputs.hostname.value

## Connect to the vm
ssh -i $privateKeyPath azureUser@$hostName