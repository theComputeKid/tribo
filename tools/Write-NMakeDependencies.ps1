
# Parses the output of cl /showIncludes and generates a .mak file
# suitable for inclusion in a NMake makefile.
function Write-NMakeDependencies {
  param(
    [string]$InputFile,
    [string]$OutputFile,
    [string]$SourceDir,
    [string]$TempDir
  )
  $lines = Get-Content $InputFile
  $src = ""
  $deps = @()
  $output = @()
  $projectRoot = (Get-Item ".").FullName

  foreach ($line in $lines) {
    if ($line -notmatch "^Note: including file:") {
      if ($src -ne "" -and $deps.Count -gt 0) {
        $obj = [System.IO.Path]::ChangeExtension($src, ".obj")
        $filteredDeps = $deps | Where-Object { $_.StartsWith($projectRoot) } | ForEach-Object { $_.Substring($projectRoot.Length).TrimStart('\', '/') }
        $depList = $filteredDeps -join " "
        $output += "$TempDir\${obj}: $SourceDir\$src $depList"
      }
      $src = $line.Trim()
      $deps = @()
    }
    else {
      $dep = $line -replace "^Note: including file:\s*", ""
      $deps += $dep.Trim()
    }
  }
  if ($src -ne "" -and $deps.Count -gt 0) {
    $obj = [System.IO.Path]::ChangeExtension($src, ".obj")
    $filteredDeps = $deps | Where-Object { $_.StartsWith($projectRoot) } | ForEach-Object { $_.Substring($projectRoot.Length).TrimStart('\', '/') }
    $depList = $filteredDeps -join " "
    $output += "$TempDir\${obj}: $SourceDir\$src $depList"
  }
  $output | Add-Content $OutputFile
}
# Example usage:
# Write-NMakeDependencies -InputFile "d:\makefile\tmp\includelist.mak" -OutputFile "d:\makefile\tmp\dependencies.mak"
