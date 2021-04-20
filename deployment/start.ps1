$moduleFolders = @()
$moduleFolders += ".\modules\"

# Browse all folders for modules
foreach ($Folder in $moduleFolders) {
    Write-Host "Exploring $Folder for modules..."
    Get-ChildItem -Path $Folder -Recurse | ForEach-Object {
        $File = $_
        # For each module found, import it and look for all the functions contained
        if ($File.Extension -eq ".psm1") {
            Write-Host "Found module $($File.BaseName)"
            Remove-Module -Name $File.BaseName -ErrorAction SilentlyContinue
            Import-Module $File.FullName
        }
    }
}