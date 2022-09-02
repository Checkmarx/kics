// Package log based on https://en.wikipedia.org/wiki/ANSI_escape_code
package log

import (
	"fmt"
	"strconv"
)

// general Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	StyleReset       = newInt(0)
	StyleBold        = newInt(1)
	StyleFaint       = newInt(2)
	StyleItalic      = newInt(3)
	StyleUnderline   = newInt(4)
	StyleSlowBlink   = newInt(5)
	StyleRapidBlink  = newInt(6)
	StyleInvert      = newInt(7)
	StyleHide        = newInt(8)
	StyleStrike      = newInt(9)
	StyleDefaultFont = newInt(10)
)

// AlternateFont returns a Style which alternates the font
//goland:noinspection GoUnusedExportedFunction
func AlternateFont(font int) Style {
	if font < 1 || font > 9 {
		panic("font can't be smaller than 1 and bigger than 9")
	}
	return newInt(font + 10)
}

// more general Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	StyleBlackLetterFont             = newInt(20)
	StyleDoubleUnderlined            = newInt(21)
	StyleNormalIntensity             = newInt(22)
	StyleNeitherItalicNorBlackLetter = newInt(23)
	StyleNotUnderlined               = newInt(24)
	StyleNotBlinking                 = newInt(25)
	StyleProportionalSpacing         = newInt(26)
	StyleNotReversed                 = newInt(27)
	StyleReveal                      = newInt(28)
	StyleNotCrossedOut               = newInt(29)
)

// foreground color Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	ForegroundColorBlack   = newInt(30)
	ForegroundColorRed     = newInt(31)
	ForegroundColorGreen   = newInt(32)
	ForegroundColorYellow  = newInt(33)
	ForegroundColorBlue    = newInt(34)
	ForegroundColorMagenta = newInt(35)
	ForegroundColorCyan    = newInt(36)
	ForegroundColorWhite   = newInt(37)
)

// SetForegroundColor returns a Style which sets the foreground color
//goland:noinspection GoUnusedExportedFunction
func SetForegroundColor(r, g, b int) Style {
	return colorStyle(38, r, g, b)
}

// background color Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	DefaultForegroundColor = newInt(39)
	BackgroundColorBlack   = newInt(40)
	BackgroundColorRed     = newInt(41)
	BackgroundColorGreen   = newInt(42)
	BackgroundColorYellow  = newInt(43)
	BackgroundColorBlue    = newInt(44)
	BackgroundColorMagenta = newInt(45)
	BackgroundColorCyan    = newInt(46)
	BackgroundColorWhite   = newInt(47)
)

// SetBackgroundColor returns a Style which sets the background color
//goland:noinspection GoUnusedExportedFunction
func SetBackgroundColor(r, g, b int) Style {
	return colorStyle(48, r, g, b)
}

// more general Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	DefaultBackgroundColor          = newInt(49)
	StyleDisableProportionalSpacing = newInt(50)
	StyleFramed                     = newInt(51)
	StyleEncircled                  = newInt(52)
	StyleOverlined                  = newInt(53)
	StyleNeitherFramedNorEncircled  = newInt(54)
	StyleNotOverlined               = newInt(55)
)

// SetUnderlineColor returns a Style which sets the underline color
//goland:noinspection GoUnusedExportedFunction
func SetUnderlineColor(r, g, b int) Style {
	return colorStyle(58, r, g, b)
}

// more general Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	StyleDefaultUnderlineColor                           = newInt(59)
	StyleIdeogramUnderlineOrRightSideLine                = newInt(60)
	StyleIdeogramDoubleUnderlineOrDoubleLineOnRightSide  = newInt(61)
	StyleIdeogramOverlineOrLeftSideLine                  = newInt(62)
	StyleIdeogramDoubleOverlineOrDoubleLineOnTheLeftSide = newInt(63)
	StyleIdeogramStressMarking                           = newInt(64)
	StyleNoIdeogramAttributes                            = newInt(65)
)

// super/subscript Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	StyleSuperscript                    = newInt(73)
	StyleSubscript                      = newInt(74)
	StyleNeitherSuperscriptNorSubscript = newInt(75)
)

// foreground bright color Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	ForegroundColorBrightBlack   = newInt(90)
	ForegroundColorBrightRed     = newInt(91)
	ForegroundColorBrightGreen   = newInt(92)
	ForegroundColorBrightYellow  = newInt(93)
	ForegroundColorBrightBlue    = newInt(94)
	ForegroundColorBrightMagenta = newInt(95)
	ForegroundColorBrightCyan    = newInt(96)
	ForegroundColorBrightWhite   = newInt(97)
)

// background bright color Style(s)
//goland:noinspection GoUnusedGlobalVariable
var (
	BackgroundColorBrightBlack   = newInt(100)
	BackgroundColorBrightRed     = newInt(101)
	BackgroundColorBrightGreen   = newInt(102)
	BackgroundColorBrightYellow  = newInt(103)
	BackgroundColorBrightBlue    = newInt(104)
	BackgroundColorBrightMagenta = newInt(105)
	BackgroundColorBrightCyan    = newInt(106)
	BackgroundColorBrightWhite   = newInt(107)
)

func newInt(c int) Style {
	return Style("\033[" + strconv.Itoa(c) + "m")
}

func newStr(str string) Style {
	return Style("\033[" + str + "m")
}

func colorStyle(c, r, g, b int) Style {
	return newStr(fmt.Sprintf("%d;%d;%d;%d;%d m", c, 2, r, g, b))
}

// Style represents a text
type Style string

// String returns the Style as string to be used in a Terminal
func (s Style) String() string {
	return string(s)
}

// And adds 2 Style(s) together
func (s Style) And(style Style) Style {
	return s + style
}

// Apply applies a given Style to the given text
func (s Style) Apply(text string) string {
	return s.String() + text + StyleReset.String()
}

// ApplyClear applies a given Style to the given text with clearing all Style(s) before
func (s Style) ApplyClear(text string) string {
	return StyleReset.String() + s.Apply(text)
}

// ApplyStyles wraps a given message in the given Style(s).
//goland:noinspection GoUnusedExportedFunction
func ApplyStyles(message string, colors ...Style) string {
	for _, color := range colors {
		message = color.Apply(message)
	}
	return message
}
