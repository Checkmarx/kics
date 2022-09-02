package api

// NewEmote creates a new custom Emoji with the given parameters
func NewEmote(name string, emoteID Snowflake, animated bool) *Emoji {
	return &Emoji{Name: name, ID: emoteID, Animated: animated}
}

// NewEmoji creates a new emoji with the given unicode
func NewEmoji(name string) *Emoji {
	return &Emoji{Name: name}
}

// Emoji allows you to interact with emojis & emotes
type Emoji struct {
	Name     string    `json:"name,omitempty"`
	ID       Snowflake `json:"id,omitempty"`
	Animated bool      `json:"animated,omitempty"`
}
