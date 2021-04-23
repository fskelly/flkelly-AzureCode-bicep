function Get-RegionShortName {
    param(
        [string] $regionName
    )

    $shortName = switch ($regionName) {
        'eastus' { 'eus'; break }
        'eastus2' { 'eus2'; break }
        'southcentralus' {'scus'; break}
        'westus2' {'wus2'; break}
        'australiaeast' {'ause'; break}
        'southeastasia' {'sea'; break}
        'northeurope' {'neu'; break}
        'uksouth' {'uks'; break}
        'westeurope' {'weu'; break}
        'centralus' {'cus'; break}
        'northcentralus' {'ncus'; break}
        'westus' {'wus'; break}
        'southafricanorth' {'zan'; break}
        'centralindia' {'cin'; break}
        'eastasia' {'eas'; break}
        'japaneast' {'jpe'; break}
        'jioindiawest' {'jwe'; break}
        'koreacentral' {'koc'; break}
        'canadacentral' {'cca'; break}
        'francecentral' {'frc'; break}
        'germanywestcentral' {'gwc'; break}
        'norwayeast' {'noe'; break}
        'switzerlandnorth' {'swn'; break}
        'uaenorth' {'uaen'; break}
        'brazilsouth' {'brs'; break}
        'centraluseuap' {'cusap'; break}
        'westus3' {'weu3'; break}
        'southafricawest' {'zaw'; break}
        'australiacentral' {'ausc'; break}
        'australiacentral2' {'ausc2'; break}
        'australiasoutheast' {'ausse'; break}
        'japanwest' {'jpw'; break}
        'koreasouth' {'kos'; break}
        'southindia' {'sin'; break}
        'westindia' {'win'; break}
        'canadaeast' {'cae'; break}
        'francesouth' {'frs'; break}
        'germanynorth' {'gen'; break}
        'norwaywest' {'now'; break}
        'switzerlandwest' {'swe'; break}
        'ukwest' {'ukw'; break}
        'uaecentral' {'uaec'; break}
        'brazilsoutheast' {'brs'; break}
        Default { $regionName }
    }
    return $shortName;
}

