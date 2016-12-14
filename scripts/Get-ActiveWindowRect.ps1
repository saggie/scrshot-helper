$thisDirectoryPath = Split-Path $MyInvocation.MyCommand.Path -Parent

New-Module -ArgumentList $thisDirectoryPath {
  param($thisDirectoryPath)

  function Get-ActiveWindowRect ()
  {
    Add-Type -Path (Join-Path $thisDirectoryPath 'WindowRectGetter.cs')
    return [WindowRectGetter]::GetForegroundWindowRect()
  }

  Export-ModuleMember -Function Get-ActiveWindowRect
}
