```bash
bicepFile="{provide-the-path-to-the-bicep-file}"
az deployment group create \
  --name firstbicep \
  --resource-group myResourceGroup \
  --template-file $bicepFile
```

```powershell
$bicepFile = "{provide-the-path-to-the-bicep-file}"
$resourceGroupName = "{provide-the-resource-group-name}"
New-AzResourceGroupDeployment `
  -Name firstbicep `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile $bicepFile
```