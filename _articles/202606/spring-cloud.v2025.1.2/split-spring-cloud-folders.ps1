[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [string]$RootPath = (Get-Location).Path,

    [Parameter()]
    [string]$ProjectPattern = 'spring-cloud-*',

    [Parameter()]
    [switch]$Copy
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $RootPath).Path

$projects = Get-ChildItem -LiteralPath $root -Directory |
    Where-Object {
        $_.Name -like $ProjectPattern -and
        $_.Name -notlike '00.*'
    }

if (-not $projects) {
    Write-Warning "在 '$root' 中没有找到匹配 '$ProjectPattern' 的项目文件夹。"
    return
}

foreach ($project in $projects) {
    $childFolders = Get-ChildItem -LiteralPath $project.FullName -Directory

    foreach ($childFolder in $childFolders) {
        $outputName = '00.{0}.{1}' -f $project.Name, $childFolder.Name
        $outputRoot = Join-Path $root $outputName
        $projectRoot = Join-Path $outputRoot $project.Name
        $destination = Join-Path $projectRoot $childFolder.Name

        if (Test-Path -LiteralPath $destination) {
            Write-Warning "跳过，目标已存在：$destination"
            continue
        }

        $action = if ($Copy) { '复制' } else { '移动' }
        if ($PSCmdlet.ShouldProcess(
                $childFolder.FullName,
                "$action 到 '$destination'"
            )) {
            New-Item -ItemType Directory -Path $projectRoot -Force | Out-Null

            if ($Copy) {
                Copy-Item -LiteralPath $childFolder.FullName `
                    -Destination $projectRoot -Recurse
            }
            else {
                Move-Item -LiteralPath $childFolder.FullName `
                    -Destination $projectRoot
            }

            Write-Host "$action：$($childFolder.FullName) -> $destination"
        }
    }
}
