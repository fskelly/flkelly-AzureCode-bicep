function Write-Header {
    param([string] $message)

    Write-Host "************************************************************************" -ForegroundColor Cyan | Out-Null
    Write-Host $message -ForegroundColor Yellow | Out-Null
    Write-Host "************************************************************************" -ForegroundColor Cyan | Out-Null
    Write-Host "" | Out-Null
}