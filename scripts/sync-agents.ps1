param([switch]$Check)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

function Sync-Mirror([string]$source, [string]$destination, [bool]$excludeGraphify = $false) {
    $source = Join-Path $root $source
    $destination = Join-Path $root $destination
    if ($Check) {
        if (-not (Test-Path -LiteralPath $destination -PathType Container)) {
            throw "Missing mirror: $destination"
        }
        $sourceFiles = @(Get-ChildItem -LiteralPath $source -File -Recurse | ForEach-Object { $_.FullName.Substring($source.Length + 1) } | Where-Object { -not $excludeGraphify -or ($_ -notmatch '^graphify[\\/]') } | Sort-Object)
        $destinationFiles = @(Get-ChildItem -LiteralPath $destination -File -Recurse | ForEach-Object { $_.FullName.Substring($destination.Length + 1) } | Where-Object { -not $excludeGraphify -or ($_ -notmatch '^graphify[\\/]') } | Sort-Object)
        if (Compare-Object $sourceFiles $destinationFiles -CaseSensitive) { throw "Mirror file list differs: $destination" }
        foreach ($file in $sourceFiles) {
            if ((Get-FileHash -LiteralPath (Join-Path $source $file)).Hash -ne (Get-FileHash -LiteralPath (Join-Path $destination $file)).Hash) {
                throw "Mirror differs: $file"
            }
        }
    } else {
        New-Item -ItemType Directory -Force -Path $destination | Out-Null
        $options = @('/MIR')
        if ($excludeGraphify) { $options += @('/XD', (Join-Path $source 'graphify'), (Join-Path $destination 'graphify')) }
        & robocopy $source $destination @options | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "Mirror failed: $destination (robocopy exit $LASTEXITCODE)" }
        $global:LASTEXITCODE = 0
    }
}

Sync-Mirror '.claude/agents' '.agents/agents'
Sync-Mirror '.claude/skills' '.agents/skills' $true
