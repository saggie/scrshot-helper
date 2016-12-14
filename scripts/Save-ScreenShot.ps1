Invoke-Expression (Join-Path $thisDirectoryPath 'Get-ActiveWindowRect.ps1') | Out-Null

New-Module {
  function Save-ScreenShot()
  {
    $outputFileName = "scrshot_" + [Convert]::ToString((Get-Date).Ticks, 16).SubString(0, 9) + ".png"
    $outputFilePath = Join-Path (Join-Path $Env:UserProfile "Desktop") $outputFileName
    
    $rect = Get-ActiveWindowRect
    
    $dpi = 1.5 # TODO consider DPI
    $x = [int]($rect.x * $dpi)
    $y = [int]($rect.y * $dpi)
    $width = [int]($rect.width * $dpi)
    $height = [int]($rect.height * $dpi)
    
    Add-Type -AssemblyName System.Drawing
    $bimap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bimap)
    
    $graphics.CopyFromScreen($x, $y, 0, 0, $bimap.Size)
    $graphics.Dispose()
    $bimap.Save($outputFilePath) 
  }
  Export-ModuleMember -Function Save-ScreenShot
}
