
## 准备文件


拆分子文件夹
```bash

#!/bin/bash

for parent in spring-data-*/; do
  parent=${parent%/}

  for child in "$parent"/*/; do
    [ -d "$child" ] || continue
    child_name=${child%/}
    child_name=${child_name##*/}
    mv "$child" "00.$parent.$child_name"
  done

  rmdir "$parent"
done

```


**拆分html**
```powershell

Get-ChildItem -Directory -Filter "00*" | ForEach-Object {
    Set-Location $_.FullName
    pw2401 dir-copy -Extension html -DeleteOriginal
    Set-Location ..
} 


git add .
git commit -m "split html files"



Get-ChildItem -Directory -Filter "00.*.copy" | ForEach-Object {
    $name = $_.Name -replace "^00\.", "01." -replace "\.copy$", ".html"
    Rename-Item $_.FullName $name
}


git add .
git commit -m "00.*.copy -> 01.*.html "


git push lang



```

**!!又忘记要子目录保持了!!**

```powershell

## 00 00 补救一下
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

```


## 

```powershell
Get-ChildItem -Directory -Filter "01.*.reference.html" | ForEach-Object {
    Set-Location $_.FullName
    Write-Host $PWD
    #translate2401.ps1 
    Set-Location ..
} 
```

