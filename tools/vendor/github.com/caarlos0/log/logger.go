package log

import (
	"fmt"
	"io"
	stdlog "log"
	"sort"
	"sync"

	"github.com/charmbracelet/lipgloss"
)

// Styles mapping.
var Styles = [...]lipgloss.Style{
	DebugLevel: lipgloss.NewStyle().Foreground(lipgloss.Color("15")),
	InfoLevel:  lipgloss.NewStyle().Foreground(lipgloss.Color("12")),
	WarnLevel:  lipgloss.NewStyle().Foreground(lipgloss.Color("11")),
	ErrorLevel: lipgloss.NewStyle().Foreground(lipgloss.Color("9")),
	FatalLevel: lipgloss.NewStyle().Foreground(lipgloss.Color("9")),
}

// Strings mapping.
var Strings = [...]string{
	DebugLevel: "•",
	InfoLevel:  "•",
	WarnLevel:  "•",
	ErrorLevel: "⨯",
	FatalLevel: "⨯",
}

const defaultPadding = 2

// assert interface compliance.
var _ Interface = (*Logger)(nil)

// Fielder is an interface for providing fields to custom types.
type Fielder interface {
	Fields() Fields
}

// Fields represents a map of entry level data used for structured logging.
type Fields map[string]interface{}

// Fields implements Fielder.
func (f Fields) Fields() Fields {
	return f
}

// Get field value by name.
func (f Fields) Get(name string) interface{} {
	return f[name]
}

// Names returns field names sorted.
func (f Fields) Names() (v []string) {
	for k := range f {
		v = append(v, k)
	}

	sort.Strings(v)
	return
}

// Logger represents a logger with configurable Level and Handler.
type Logger struct {
	mu      sync.Mutex
	Writer  io.Writer
	Level   Level
	Padding int
}

// ResetPadding resets the padding to default.
func (l *Logger) ResetPadding() {
	l.Padding = defaultPadding
}

// IncreasePadding increases the padding 1 times.
func (l *Logger) IncreasePadding() {
	l.Padding += defaultPadding
}

// DecreasePadding decreases the padding 1 times.
func (l *Logger) DecreasePadding() {
	l.Padding -= defaultPadding
}

func (l *Logger) handleLog(e *Entry) error {
	style := Styles[e.Level]
	level := Strings[e.Level]
	names := e.Fields.Names()

	l.mu.Lock()
	defer l.mu.Unlock()

	fmt.Fprintf(
		l.Writer,
		"%s %-*s",
		style.Bold(true).Render(
			fmt.Sprintf("%*s", 1+l.Padding, level),
		),
		l.rightPadding(names),
		e.Message,
	)

	for _, name := range names {
		fmt.Fprintf(l.Writer, " %s=%v", style.Render(name), e.Fields.Get(name))
	}

	fmt.Fprintln(l.Writer)
	return nil
}

func (l *Logger) rightPadding(names []string) int {
	if len(names) == 0 {
		return 0
	}
	return 50 - l.Padding
}

// WithFields returns a new entry with `fields` set.
func (l *Logger) WithFields(fields Fielder) *Entry {
	return NewEntry(l).WithFields(fields.Fields())
}

// WithField returns a new entry with the `key` and `value` set.
//
// Note that the `key` should not have spaces in it - use camel
// case or underscores
func (l *Logger) WithField(key string, value interface{}) *Entry {
	return NewEntry(l).WithField(key, value)
}

// WithError returns a new entry with the "error" set to `err`.
func (l *Logger) WithError(err error) *Entry {
	return NewEntry(l).WithError(err)
}

// Debug level message.
func (l *Logger) Debug(msg string) {
	NewEntry(l).Debug(msg)
}

// Info level message.
func (l *Logger) Info(msg string) {
	NewEntry(l).Info(msg)
}

// Warn level message.
func (l *Logger) Warn(msg string) {
	NewEntry(l).Warn(msg)
}

// Error level message.
func (l *Logger) Error(msg string) {
	NewEntry(l).Error(msg)
}

// Fatal level message, followed by an exit.
func (l *Logger) Fatal(msg string) {
	NewEntry(l).Fatal(msg)
}

// Debugf level formatted message.
func (l *Logger) Debugf(msg string, v ...interface{}) {
	NewEntry(l).Debugf(msg, v...)
}

// Infof level formatted message.
func (l *Logger) Infof(msg string, v ...interface{}) {
	NewEntry(l).Infof(msg, v...)
}

// Warnf level formatted message.
func (l *Logger) Warnf(msg string, v ...interface{}) {
	NewEntry(l).Warnf(msg, v...)
}

// Errorf level formatted message.
func (l *Logger) Errorf(msg string, v ...interface{}) {
	NewEntry(l).Errorf(msg, v...)
}

// Fatalf level formatted message, followed by an exit.
func (l *Logger) Fatalf(msg string, v ...interface{}) {
	NewEntry(l).Fatalf(msg, v...)
}

// log the message, invoking the handler. We clone the entry here
// to bypass the overhead in Entry methods when the level is not
// met.
func (l *Logger) log(level Level, e *Entry, msg string) {
	if level < l.Level {
		return
	}

	if err := l.handleLog(e.finalize(level, msg)); err != nil {
		stdlog.Printf("error logging: %s", err)
	}
}
