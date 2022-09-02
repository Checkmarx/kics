package discord

import (
	"time"

	"github.com/disgoorg/snowflake/v2"
)

type StagePrivacyLevel int

const (
	StagePrivacyLevelPublic StagePrivacyLevel = iota + 1
	StagePrivacyLevelGuildOnly
)

type StageInstance struct {
	ID                   snowflake.ID      `json:"id"`
	GuildID              snowflake.ID      `json:"guild_id"`
	ChannelID            snowflake.ID      `json:"channel_id"`
	Topic                string            `json:"topic"`
	PrivacyLevel         StagePrivacyLevel `json:"privacy_level"`
	DiscoverableDisabled bool              `json:"discoverable_disabled"`
}

func (e StageInstance) CreatedAt() time.Time {
	return e.ID.Time()
}

type StageInstanceCreate struct {
	ChannelID             snowflake.ID      `json:"channel_id"`
	Topic                 string            `json:"topic,omitempty"`
	PrivacyLevel          StagePrivacyLevel `json:"privacy_level,omitempty"`
	SendStartNotification bool              `json:"send_start_notification"`
}

type StageInstanceUpdate struct {
	Topic        *string            `json:"topic,omitempty"`
	PrivacyLevel *StagePrivacyLevel `json:"privacy_level,omitempty"`
}
