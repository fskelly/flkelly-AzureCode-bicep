## Set Variables
$rgName = ''
$rgLocation = ''

## Create ResourceGroup if needed
New-AzResourceGroup -Name $rgName -Location $rgLocation

# bicep file name
$bicepFile = '.\main.bicep'

# deploy bicep file
New-AzResourceGroupDeployment -Name 'vmssdeploy' -ResourceGroupName $rgName -TemplateFile $bicepFile 