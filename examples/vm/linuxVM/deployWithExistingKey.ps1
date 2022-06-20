## Get key data
$publicKeyPath = ""
$sshKey = Get-Content $publicKeyPath
$secureSSHKey = ConvertTo-SecureString $sshKey -AsPlainText -Force

$privateKeyPath = ""

## Deploy to Azure
$resourceGroupName = ""
$resourceGroupLocation = ""
$userName = ""
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./main.bicep -adminUsername $userName -adminPasswordOrKey $secureSSHKey
$hostName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName).outputs.hostname.value

## Adding slight delay
Start-Sleep 5

## Connect to the vm
ssh -i $privateKeyPath $userName@$hostName