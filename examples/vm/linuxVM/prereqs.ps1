## Pre-req

## Create required ssh-keys
## Requires ssh-keygen to be installed

$vmName = "testvm"
$keyLocation  = $env:USERPROFILE + "\.ssh\"
$privateKeyName = $vmName + "-priv-key"
$publicKeyName = $vmName + "-priv-key.pub"
$privateKeyPath = $keyLocation + $privateKeyName
$publicKeyPath  = $keyLocation + $publicKeyName

$password = read-host "password" -AsSecureString

#$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
#$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

ssh-keygen -m PEM -t rsa -b 4096 -C $vmName -f $privateKeyPath -N $password 

notepad $publicKeyPath

##Deploy

$sshKey = Get-Content $publicKeyPath   