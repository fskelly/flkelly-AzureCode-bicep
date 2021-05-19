Example  
```powershell
$resourceGroupName = ""
New-AzResourceGroupDeployment -Name firstbicep -ResourceGroupName $resourceGroupName -TemplateFile .\vm.json
```

Example with **override** (-vmOS)
```powershell
$resourceGroupName = ""
New-AzResourceGroupDeployment -Name firstbicep -ResourceGroupName $resourceGroupName -TemplateFile .\vm.json -vmOS '2019-Datacenter'
```