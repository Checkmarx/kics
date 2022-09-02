package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

// VoiceState from Discord
type VoiceState struct {
	GuildID                 snowflake.ID  `json:"guild_id,omitempty"`
	ChannelID               *snowflake.ID `json:"channel_id"`
	UserID                  snowflake.ID  `json:"user_id"`
	SessionID               string        `json:"session_id"`
	GuildDeaf               bool          `json:"deaf"`
	GuildMute               bool          `json:"mute"`
	SelfDeaf                bool          `json:"self_deaf"`
	SelfMute                bool          `json:"self_mute"`
	SelfStream              bool          `json:"self_stream"`
	SelfVideo               bool          `json:"self_video"`
	Suppress                bool          `json:"suppress"`
	RequestToSpeakTimestamp *time.Time    `json:"request_to_speak_timestamp"`
}

type UserVoiceStateUpdate struct {
	ChannelID               snowflake.ID              `json:"channel_id"`
	Suppress                *bool                     `json:"suppress,omitempty"`
	RequestToSpeakTimestamp *json.Nullable[time.Time] `json:"request_to_speak_timestamp,omitempty"`
}
