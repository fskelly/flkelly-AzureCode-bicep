function Select-AzureRegion {
    param(

    )

    $regions=$(az account list-locations --query "[?not_null(metadata.latitude)] .{RegionName:name}" --output json)

    [int]$regionCount = ($regions | ConvertFrom-Json).count
    $regions = ($regions | ConvertFrom-Json)
    Write-Header "Select a region; found $regionCount"
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

    $regionName = $regions[$regionChoice].regionName

    ## cll imported module to get the result
    #Get-RegionShortName $regionName
    $selectedRegion = $regionName
    $selectedRegionShortName = Get-RegionShortName $regionName

    Get-RegionShortName $regionName
    Write-Header "The selected region is $selectedRegion and the short code is $selectedRegionShortName"

    return $regionName;
}