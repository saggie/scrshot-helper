New-Module {
  function Save-ScreenShot()
  {
    $outputFileName = "scrshot_" + [Convert]::ToString((Get-Date).Ticks, 16).SubString(0, 9) + ".png"
    $outputFilePath = Join-Path (Join-Path $Env:UserProfile "Desktop") $outputFileName
    
    Add-Type -AssemblyName System.Windows.Forms
    $width = [int](([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width) * 1.0) # TODO consider DPI
    $height = [int](([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height) * 1.0) # TODO consider DPI
    
    Add-Type -AssemblyName System.Drawing
    $bimap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bimap)
    
    $graphics.CopyFromScreen(0, 0, 0, 0, $bimap.Size)
    $graphics.Dispose()
    $bimap.Save($outputFilePath) 
  }
  Export-ModuleMember -Function Save-ScreenShot
}
