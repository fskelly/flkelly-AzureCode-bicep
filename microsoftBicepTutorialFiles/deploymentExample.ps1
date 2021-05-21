$rgName = "" ## bicep-test
$rgLocation = "" ## westeurope
New-AzResourceGroup -Name $rgName -Location $rgLocation

$templateFile = "" ## ".\main.json"
New-AzResourceGroupDeployment -TemplateFile $templateFile -ResourceGroupName $rgName