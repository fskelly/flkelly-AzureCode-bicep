## Set Variables
$rgName = ''
$rgLocation = ''

## Create ResourceGroup if needed
New-AzResourceGroup -Name $rgName -Location $rgLocation

# bicep file name for "basic example" - this will create a storage account
$bicepFile = '.\main.bicep'

# bicep file name for "advanced example" - this will use an EXISTING storage account
$bicepFile = '.\advanced.bicep'

# deploy bicep file
New-AzResourceGroupDeployment -Name 'vmssdeploy' -ResourceGroupName $rgName -TemplateFile $bicepFile 