## Pre-req

## Create required ssh-keys
## Requires ssh-keygen to be installed

$vmName = "vm1-test"
$keyLocation  = $env:USERPROFILE + "\.ssh\"
$privateKeyName = $vmName + "-key"
$publicKeyName = $vmName + "-key.pub"
$privateKeyPath = $keyLocation + $privateKeyName
$publicKeyPath  = $keyLocation + $publicKeyName

#$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
#$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

ssh-keygen -m PEM -t rsa -b 2048 -C $vmName -f $privateKeyPath
#notepad $publicKeyPath

##Deploy
$sshKey = Get-Content $publicKeyPath
$secureSSHKey = ConvertTo-SecureString $sshKey -AsPlainText -Force

## Deploy to Azure
$resourceGroupName = ""
$resourceGroupLocation = ""
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./main.bicep -adminUsername "azureUser" -adminPasswordOrKey $secureSSHKey
