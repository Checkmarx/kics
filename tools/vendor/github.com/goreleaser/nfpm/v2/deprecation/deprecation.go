// Package deprecation provides centralized deprecation notice messaging for nfpm.
package deprecation

import (
	"fmt"
	"io"
	"os"
)

type prefixed struct{ io.Writer }

func (p prefixed) Write(b []byte) (int, error) {
	return p.Writer.Write(append([]byte("DEPRECATION WARNING: "), b...))
}

var Noticer io.Writer = prefixed{os.Stderr}

// Print prints the given string to the Noticer.
func Print(s string) {
	fmt.Fprint(Noticer, s)
}

// Println printslns the given string to the Noticer.
func Println(s string) {
	fmt.Fprintln(Noticer, s)
}

// Printf printfs the given string to the Noticer.
func Printf(format string, a ...interface{}) {
	fmt.Fprintf(Noticer, format, a...)
}
