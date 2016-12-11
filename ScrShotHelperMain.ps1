# load modules
$thisDirectoryPath = Split-Path $MyInvocation.MyCommand.Path -Parent
Invoke-Expression (Join-Path $thisDirectoryPath 'HotKeyRegisterer.ps1') | Out-Null
Invoke-Expression (Join-Path $thisDirectoryPath 'Save-ScreenShot.ps1') | Out-Null

function Start-Main()
{
  $Script:ThisIcon = $null

  function Close-ThisIcon()
  {
    Unregister-HotKeys
    $Script:ThisIcon.Visible = $false
  }
  
  function Create-ThisIcon()
  {
    Add-Type -AssemblyName System.Windows.Forms
    $notifyIcon = New-Object System.Windows.Forms.NotifyIcon

    # create context menu and its item
    $exitMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem("Exit ScrShotHelper")
    $exitMenuItem.Add_Click({Close-ThisIcon})
    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $contextMenu.Items.Add($exitMenuItem) | Out-Null

    # setup the notify icon
    $notifyIcon.ContextMenuStrip = $contextMenu
    $psExeFilePath = Join-Path $Script:PSHOME "powershell.exe"
    $notifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($psExeFilePath)
    $notifyIcon.Text = "ScrShotHelper"
    $notifyIcon.Visible = $true

    return $notifyIcon
  }

  $Script:ThisIcon = Create-ThisIcon

  $hotKeyList = @(
    @{ KeyString = 'Ctrl+PrintScreen'; Procedure = { Save-ScreenShot } }
  )
  Register-HotKeys -HotKeyList $hotKeyList
}
Start-Main

