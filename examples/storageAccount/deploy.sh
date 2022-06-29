bicepFile=main.bicep 
echo $bicepFile
date=$(date +"%d%m%Y-%H%M%S")
echo $date
deploymentName=${bicepFile}-$(date +"%d%m%Y-%H%M%S")"-deployment"


az group create --name rg-bicep --location northeurope
az deployment group create --name $deploymentName --resource-group rg-bicep --template-file $bicepFile

$deploymentName = ($bicepFile).Substring(2) + "-" +(get-date -Format ddMMyyyy-hhmmss) + "-deployment"