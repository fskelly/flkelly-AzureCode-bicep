## Pre-req

## Create required ssh-keys
## Requires ssh-keygen to be installed

$vmName = ""
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
$userName = ""
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./main.bicep -adminUsername $userName -adminPasswordOrKey $secureSSHKey

$hostName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName).outputs.hostname.value

## Adding slight delay
Start-Sleep 5

## Connect to the vm
ssh -i $privateKeyPath $userName@$hostName