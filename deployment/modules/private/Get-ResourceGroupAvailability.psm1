function Get-ResourceGroupAvailability {
    param (
        [Parameter(Position = 1, mandatory = $true)]
        [ValidateLength(1, 8)]
        [string]$alias,
        [Parameter(Position = 2, mandatory = $true)]
        [ValidateLength(1, 8)]
        [string]$shortname,
        [Parameter(Position = 3, mandatory = $true)]
        [ValidateLength(1, 14)]
        [string]$region
        # [Parameter(Position = 3, mandatory = $true)]
        # [ValidateLength(1, 3)]
        # [string]$startSuffix
        
    )
    $counter = 1
    do {
        $startSuffix = $counter
        ([string]$suffix) = ([string]$startSuffix).PadLeft(3,'0')
        $rgName = $alias + '-' +$shortname + '-' + $suffix
        Write-Header "Checking if Resource Group - $rgName - exists"
        $rgTest = get-azresourceGroup -name $rgName -Location $region -ErrorAction SilentlyContinue
        $counter++
    } until ($null -eq $rgtest)
    return $rgName
}