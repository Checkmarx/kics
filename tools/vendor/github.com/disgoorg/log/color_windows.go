package log

import (
	"os"
	"runtime"
	"syscall"
)

// based off https://github.com/TwinProduction/go-color/blob/master/color_windows.go
func init() {
	if runtime.GOOS == "windows" {
		// Try to make ANSI work
		handle := syscall.Handle(os.Stdout.Fd())
		kernel32DLL := syscall.NewLazyDLL("kernel32.dll")
		setConsoleModeProc := kernel32DLL.NewProc("SetConsoleMode")
		// If it fails, fallback to no Styles
		if _, _, err := setConsoleModeProc.Call(uintptr(handle), 0x0001|0x0002|0x0004); err != nil && err.Error() != "The operation completed successfully." {
			EnableColors = false
		}
	}
}
