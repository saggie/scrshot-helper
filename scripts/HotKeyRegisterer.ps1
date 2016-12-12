$thisDirectoryPath = Split-Path $MyInvocation.MyCommand.Path -Parent

New-Module -ArgumentList $thisDirectoryPath {
  param($thisDirectoryPath)

  $Script:HotKeyManagerInstance = $null

  function Register-HotKeys($HotKeyList)
  {
    Add-Type -Path (Join-Path $thisDirectoryPath 'HotKeyManager.cs') `
             -ReferencedAssemblies ('System.Windows.Forms', 'System.Core')
    $Script:HotKeyManagerInstance = New-Object HotKeyManager

    $MODKEY_VALUE_TABLE = @{
      ALT   = 0x0001;
      CTRL  = 0x0002;
      SHIFT = 0x0004;
      NA    = 0x0000;
    }
    
    filter Get-ModifierKeyValue
    {
      if ($MODKEY_VALUE_TABLE.Contains($_))
      {
        return $MODKEY_VALUE_TABLE[$_]
      }
      return $MODKEY_VALUE_TABLE['NA']
    }

    function DivideInto-ModKeyAndKey($KeyString)
    {
      $keyList = $KeyString.ToUpper().Split('+') | foreach{ $_.Trim() }

      $modkey = ($keyList | Get-ModifierKeyValue) -join ' -bor ' | Invoke-Expression

      $key = ($keyList | where{ -not($MODKEY_VALUE_TABLE.Contains($_)) } | foreach{ [Windows.Forms.Keys]::"$_" })[0]

      return $modkey, $key
    }

    # register HotKey and its procedure
    $HotKeyList | foreach {
      $modKey, $key = DivideInto-ModKeyAndKey $_.KeyString
      $procedure = $_.Procedure
      $Script:HotKeyManagerInstance.RegisterHotKeyAndItsProcedure($modKey, $key, $procedure)
    }

    # (for debug)
    $bindingInfo = $Script:HotKeyManagerInstance.GetBindingsInformation()

    # start HotKey observing
    [void]$Script:HotKeyManagerInstance.ShowDialog()
  }

  function Unregister-HotKeys()
  {
    if (-not $Script:HotKeyManagerInstance.IsDisposed)
    {
      $Script:HotKeyManagerInstance.Close()
    }
  }

  Export-ModuleMember -Function Register-HotKeys
  Export-ModuleMember -Function Unregister-HotKeys
}
