Param([switch]$DryRun)

$Root = "."
$Ignore = @("\.git","build","\.dart_tool","ios\\Runner\.app","android\\app\\build","web\\build","macos\\Build","linux\\build","windows\\build")

# Ordered replacements: specific → general
$Map = [ordered]@{
  "package:game_ui/nav.dart"     = "package:ui_shell/nav.dart";
  "package:game_ui/theme.dart"   = "package:ui_shell/theme.dart";
  "package:game_ui/src/nav/"     = "package:ui_shell/src/nav/";
  "package:game_ui/src/theme/"   = "package:ui_shell/src/theme/";
}

Write-Host "== Fixing imports (game_ui -> ui_shell) =="
Write-Host ("Dry run: {0}" -f ($DryRun.IsPresent))

# Gather .dart files
$files = Get-ChildItem -Path $Root -Recurse -Include *.dart -File | Where-Object {
  $path = $_.FullName
  foreach ($skip in $Ignore) {
    if ($path -match $skip) { return $false }
  }
  return $true
}

if (-not $files) {
  Write-Host "No .dart files found (after ignores)."
  exit 0
}

$changed = 0
foreach ($f in $files) {
  $text = Get-Content -LiteralPath $f.FullName -Raw
  $new  = $text
  foreach ($kv in $Map.GetEnumerator()) {
    $from = [regex]::Escape($kv.Key)
    $to   = $kv.Value
    $new  = [regex]::Replace($new, $from, $to)
  }
  if ($new -ne $text) {
    if ($DryRun) {
      Write-Host "[DRY] would update: $($f.FullName)"
    } else {
      Set-Content -LiteralPath $f.FullName -Value $new -Encoding UTF8
      Write-Host "[FIXED] $($f.FullName)"
    }
    $changed++
  }
}

Write-Host ("Files updated: {0}" -f $changed)
Write-Host "Tip: run 'melos run analyze' or 'dart analyze' next."
