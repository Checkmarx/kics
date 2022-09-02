package discord

type Locale string

func (l Locale) String() string {
	if name, ok := Locales[l]; ok {
		return name
	}
	return LocaleUnknown.String()
}

func (l Locale) Code() string {
	return string(l)
}

const (
	LocaleEnglishUS    Locale = "en-US"
	LocaleEnglishGB    Locale = "en-GB"
	LocaleBulgarian    Locale = "bg"
	LocaleChineseCN    Locale = "zh-CN"
	LocaleChineseTW    Locale = "zh-TW"
	LocaleCroatian     Locale = "hr"
	LocaleCzech        Locale = "cs"
	LocaleDanish       Locale = "da"
	LocaleDutch        Locale = "nl"
	LocaleFinnish      Locale = "fi"
	LocaleFrench       Locale = "fr"
	LocaleGerman       Locale = "de"
	LocaleGreek        Locale = "el"
	LocaleHindi        Locale = "hi"
	LocaleHungarian    Locale = "hu"
	LocaleItalian      Locale = "it"
	LocaleJapanese     Locale = "ja"
	LocaleKorean       Locale = "ko"
	LocaleLithuanian   Locale = "lt"
	LocaleNorwegian    Locale = "no"
	LocalePolish       Locale = "pl"
	LocalePortugueseBR Locale = "pt-BR"
	LocaleRomanian     Locale = "ro"
	LocaleRussian      Locale = "ru"
	LocaleSpanishES    Locale = "es-ES"
	LocaleSwedish      Locale = "sv-SE"
	LocaleThai         Locale = "th"
	LocaleTurkish      Locale = "tr"
	LocaleUkrainian    Locale = "uk"
	LocaleVietnamese   Locale = "vi"
	LocaleUnknown      Locale = ""
)

var Locales = map[Locale]string{
	LocaleEnglishUS:    "English (United States)",
	LocaleEnglishGB:    "English (Great Britain)",
	LocaleBulgarian:    "Bulgarian",
	LocaleChineseCN:    "Chinese (China)",
	LocaleChineseTW:    "Chinese (Taiwan)",
	LocaleCroatian:     "Croatian",
	LocaleCzech:        "Czech",
	LocaleDanish:       "Danish",
	LocaleDutch:        "Dutch",
	LocaleFinnish:      "Finnish",
	LocaleFrench:       "French",
	LocaleGerman:       "German",
	LocaleGreek:        "Greek",
	LocaleHindi:        "Hindi",
	LocaleHungarian:    "Hungarian",
	LocaleItalian:      "Italian",
	LocaleJapanese:     "Japanese",
	LocaleKorean:       "Korean",
	LocaleLithuanian:   "Lithuanian",
	LocaleNorwegian:    "Norwegian",
	LocalePolish:       "Polish",
	LocalePortugueseBR: "Portuguese (Brazil)",
	LocaleRomanian:     "Romanian",
	LocaleRussian:      "Russian",
	LocaleSpanishES:    "Spanish (Spain)",
	LocaleSwedish:      "Swedish",
	LocaleThai:         "Thai",
	LocaleTurkish:      "Turkish",
	LocaleUkrainian:    "Ukrainian",
	LocaleVietnamese:   "Vietnamese",
	LocaleUnknown:      "unknown",
}
