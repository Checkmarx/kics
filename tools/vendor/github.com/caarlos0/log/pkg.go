package log

import (
	"io"
	"os"
)

// singletons ftw?
var Log Interface = New(os.Stderr)

// New creates a new logger.
func New(w io.Writer) *Logger {
	return &Logger{
		Writer:  w,
		Padding: defaultPadding,
		Level:   InfoLevel,
	}
}

// SetLevel sets the log level. This is not thread-safe.
func SetLevel(l Level) {
	if logger, ok := Log.(*Logger); ok {
		logger.Level = l
	}
}

// SetLevelFromString sets the log level from a string, panicing when invalid. This is not thread-safe.
func SetLevelFromString(s string) {
	if logger, ok := Log.(*Logger); ok {
		logger.Level = MustParseLevel(s)
	}
}

// ResetPadding resets the padding to default.
func ResetPadding() {
	Log.ResetPadding()
}

// IncreasePadding increases the padding 1 times.
func IncreasePadding() {
	Log.IncreasePadding()
}

// DecreasePadding decreases the padding 1 times.
func DecreasePadding() {
	Log.DecreasePadding()
}

// WithFields returns a new entry with `fields` set.
func WithFields(fields Fielder) *Entry {
	return Log.WithFields(fields)
}

// WithField returns a new entry with the `key` and `value` set.
func WithField(key string, value interface{}) *Entry {
	return Log.WithField(key, value)
}

// WithError returns a new entry with the "error" set to `err`.
func WithError(err error) *Entry {
	return Log.WithError(err)
}

// Debug level message.
func Debug(msg string) {
	Log.Debug(msg)
}

// Info level message.
func Info(msg string) {
	Log.Info(msg)
}

// Warn level message.
func Warn(msg string) {
	Log.Warn(msg)
}

// Error level message.
func Error(msg string) {
	Log.Error(msg)
}

// Fatal level message, followed by an exit.
func Fatal(msg string) {
	Log.Fatal(msg)
}

// Debugf level formatted message.
func Debugf(msg string, v ...interface{}) {
	Log.Debugf(msg, v...)
}

// Infof level formatted message.
func Infof(msg string, v ...interface{}) {
	Log.Infof(msg, v...)
}

// Warnf level formatted message.
func Warnf(msg string, v ...interface{}) {
	Log.Warnf(msg, v...)
}

// Errorf level formatted message.
func Errorf(msg string, v ...interface{}) {
	Log.Errorf(msg, v...)
}

// Fatalf level formatted message, followed by an exit.
func Fatalf(msg string, v ...interface{}) {
	Log.Fatalf(msg, v...)
}
