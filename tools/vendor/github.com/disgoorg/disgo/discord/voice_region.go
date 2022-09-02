package discord

import "github.com/disgoorg/snowflake/v2"

// VoiceRegion (https://discord.com/developers/docs/resources/voice#voice-region-object)
type VoiceRegion struct {
	ID         snowflake.ID `json:"id"`
	Name       string       `json:"name"`
	Vip        bool         `json:"vip"`
	Optimal    bool         `json:"optimal"`
	Deprecated bool         `json:"deprecated"`
	Custom     bool         `json:"custom"`
}
