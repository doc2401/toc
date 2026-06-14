Get-ChildItem -Directory -Filter "00.*.copy" | ForEach-Object {
    $name = $_.Name -replace "^00\.", "01." -replace "\.copy$", ".html"
    Rename-Item $_.FullName $name
}
