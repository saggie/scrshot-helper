New-Module {
  function Save-ScreenShot
  {
    Add-Type -AssemblyName System.Windows.Forms

    # press Alt+PrintScreen
    [System.Windows.Forms.SendKeys]::SendWait("%{PRTSC}")

    $clipboardImage = [Windows.Forms.Clipboard]::GetImage()
    if ($clipboardImage)
    {
      $outputFileName = "scrshot_" + [Convert]::ToString((Get-Date).Ticks, 16).SubString(0, 9) + ".png"
      $outputFilePath = Join-Path (Join-Path $Env:UserProfile "Desktop") $outputFileName
      $clipboardImage.Save($outputFilePath)
    }
  }
  Export-ModuleMember -Function Save-ScreenShot
}
