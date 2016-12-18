New-Module {
  function Save-ScreenShot
  {
    Add-Type -AssemblyName System.Windows.Forms

    # save (push) clipboard
    $clipText = [Windows.Forms.Clipboard]::GetText()

    # clear clipboard
    [Windows.Forms.Clipboard]::SetText(" ")
    Start-Sleep -Milliseconds 100

    # press Alt+PrintScreen
    [System.Windows.Forms.SendKeys]::SendWait("%{PRTSC}")
    Start-Sleep -Milliseconds 100

    $clipboardImage = [Windows.Forms.Clipboard]::GetImage()
    Start-Sleep -Milliseconds 100
    
    if ($clipboardImage)
    {
      $outputFileName = "scrshot_" + [Convert]::ToString((Get-Date).Ticks, 16).SubString(2, 7) + ".png"
      $outputFilePath = Join-Path (Join-Path $Env:UserProfile "Desktop") $outputFileName
      $clipboardImage.Save($outputFilePath)
    }
    
    # load (pop) cliptext
    [Windows.Forms.Clipboard]::SetText($clipText)
  }
  Export-ModuleMember -Function Save-ScreenShot
}
