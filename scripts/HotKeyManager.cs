using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;

public class HotKeyManager : Form
{
    [DllImport("user32.dll")]
    private extern static int RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, Keys vk);

    [DllImport("user32.dll")]
    private extern static int UnregisterHotKey(IntPtr hWnd, int id);

    private List<HotKeyAndProcedureBinding> hotKeyAndProcedureBindings = new List<HotKeyAndProcedureBinding>();
    private class HotKeyAndProcedureBinding
    {
        public int modKey;
        public Keys key;
        public int hotKeyId;
        public ThreadStart procedure;
        public override string ToString()
        {
            return string.Format(
                "{{modKey={0}, key={1}, hotKeyId={2}, procedure={3}}}",
                modKey, key, hotKeyId, procedure
            );
        }
    }

    public HotKeyManager()
    {
        this.WindowState = System.Windows.Forms.FormWindowState.Minimized;
        this.ShowInTaskbar = false;
    }

    private static int idIndex = 0x0000;

    public void RegisterHotKeyAndItsProcedure(int modKey, Keys key, ThreadStart procedure)
    {
        while (idIndex <= 0xbfff)
        {
            if (RegisterHotKey(this.Handle, idIndex, modKey, key) != 0)
            {
                var binding = new HotKeyAndProcedureBinding();
                binding.modKey = modKey;
                binding.key = key;
                binding.hotKeyId = idIndex++;
                binding.procedure = procedure;
                hotKeyAndProcedureBindings.Add(binding);
                break;
            }
            idIndex++;
        }
    }

    public string GetBindingsInformation()
    {
        var bindingListInString = hotKeyAndProcedureBindings.Select(b => b.ToString()).ToList();
        return "[" + string.Join(", ", bindingListInString) + "]";
    }

    private const int WM_HOTKEY = 0x0312;

    protected override void WndProc(ref Message message)
    {
        base.WndProc(ref message);

        if (message.Msg == WM_HOTKEY)
        {
            foreach (var eachBinding in hotKeyAndProcedureBindings)
            {
                if ((int)message.WParam == eachBinding.hotKeyId)
                {
                    eachBinding.procedure();
                }
            }
        }
    }

    protected override void Dispose(bool disposing)
    {
        // Unregister all HotKeys
        hotKeyAndProcedureBindings.ForEach(binding => UnregisterHotKey(this.Handle, binding.hotKeyId));

        base.Dispose(disposing);
    }
}
