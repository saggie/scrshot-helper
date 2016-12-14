using System;
using System.Runtime.InteropServices;

public class WindowRectGetter
{
    [DllImport("user32.dll")]
    //[return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out WindowRectRaw lpRect);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    public static WindowRect GetForegroundWindowRect() {
        IntPtr hwnd = GetForegroundWindow();
        var rawRect = new WindowRectRaw();
        GetWindowRect(hwnd, out rawRect);
        return new WindowRect(rawRect);
    }
}

public struct WindowRectRaw
{
    public int left;
    public int top;
    public int right;
    public int bottom;
}

public class WindowRect
{
    public int x;
    public int y;
    public int width;
    public int height;

    public WindowRect(WindowRectRaw raw) {
        this.x = raw.left;
        this.y = raw.top;
        this.width = raw.right - raw.left;
        this.height = raw.bottom - raw.top;
    }
}
