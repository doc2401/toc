Get-ChildItem -Directory -Filter "00*" | ForEach-Object {
    Set-Location $_.FullName
    pw2401 dir-copy -Extension html -DeleteOriginal
    Set-Location ..
}
