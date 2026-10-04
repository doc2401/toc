Get-ChildItem -Directory -Filter "01.*" | ForEach-Object {
    $parts = $_.Name -split '\.', 3

    if ($parts.Count -ge 3) {
        $projectName = $parts[1]
        $projectPath = Join-Path $_.FullName $projectName

        New-Item -ItemType Directory -Path $projectPath -Force | Out-Null

        Get-ChildItem $_.FullName -Directory |
            Where-Object Name -ne $projectName |
            Move-Item -Destination $projectPath
    }
}