function Get-RegionShortName {
    param(
        [string] $regionName
    )

    $shortName = switch ($regionname) {
        'EastUS' { 'eus'; break }
        'EastUS2' { 'eus2'; break }
        'WestUS' { 'wus'; break }
        'southafricanorth' { 'zan'; break }
        Default { $regionName }
    }

    return $shortName;
}