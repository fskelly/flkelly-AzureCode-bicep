$regions=$(az account list-locations --query "[?not_null(metadata.latitude)] .{RegionName:name}" --output json)

[int]$regionCount = ($regions | ConvertFrom-Json).count
$regions = ($regions | ConvertFrom-Json)
Write-Host "Found" $regionCount "regions"
$i = 0
foreach ($region in $regions)
{
  $sregionValue = $i
  Write-Host $sregionValue ":" $region.regionName
  $i++
}
Do 
{
  [int]$regionChoice = read-host -prompt "Select number & press enter"
} 
until ($regionChoice -le $regionCount)

Write-Host "You selected" $regions[$regionChoice].regionName

## cll imported module to get the result
Get-RegionShortName $regions[$regionChoice].regionName