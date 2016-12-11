$thisDirectoryPath = Split-Path $MyInvocation.MyCommand.Path -Parent
Invoke-Expression (Join-Path $thisDirectoryPath 'HotKeyRegisterer.ps1') | Out-Null

$hotKeyList = @(
  @{ KeyString = 'Ctrl+Shift+W'; Procedure = { Write-Host '"Write-Host" called.' } },
  @{ KeyString = 'Ctrl+Shift+N'; Procedure = { cmd /c notepad } },
  @{ KeyString = 'Ctrl+Shift+C'; Procedure = { cmd /c calc } },
  @{ KeyString = 'Ctrl+Shift+Q'; Procedure = { Unregister-HotKeys } }
)

Register-HotKeys -HotKeyList $hotKeyList
