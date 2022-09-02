package discord

import (
	"time"

	"github.com/disgoorg/snowflake/v2"
)

// GuildTemplate is a template used for copying guilds https://discord.com/developers/docs/resources/guild-template
type GuildTemplate struct {
	Code        string        `json:"code"`
	Name        string        `json:"name"`
	Description *string       `json:"description,omitempty"`
	UsageCount  int           `json:"usage_count"`
	CreatorID   snowflake.ID  `json:"creator_id"`
	Creator     User          `json:"creator"`
	CreatedAt   time.Time     `json:"created_at"`
	UpdatedAt   time.Time     `json:"updated_at"`
	GuildID     snowflake.ID  `json:"source_guild_id"`
	Guild       TemplateGuild `json:"serialized_source_guild"`
	IsDirty     bool          `json:"is_dirty,omitempty"`
}

type TemplateGuild struct {
	Name                        string                     `json:"name"`
	Description                 *string                    `json:"description"`
	Icon                        *string                    `json:"icon_hash"`
	VerificationLevel           VerificationLevel          `json:"verification_level"`
	DefaultMessageNotifications MessageNotificationsLevel  `json:"default_message_notifications"`
	ExplicitContentFilter       ExplicitContentFilterLevel `json:"explicit_content_filter"`
	SystemChannelID             *snowflake.ID              `json:"system_channel_id"`
	SystemChannelFlags          SystemChannelFlags         `json:"system_channel_flags"`
	PreferredLocale             string                     `json:"preferred_locale"`
	AfkChannelID                *snowflake.ID              `json:"afk_channel_id"`
	AfkTimeout                  int                        `json:"afk_timeout"`
	Roles                       []GuildCreateRole          `json:"roles"`
	Channels                    []GuildCreateChannel       `json:"channels"`
}

// GuildTemplateCreate is the data used to create a GuildTemplate
type GuildTemplateCreate struct {
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
}

// GuildTemplateUpdate is the data used to update a GuildTemplate
type GuildTemplateUpdate struct {
	Name        *string `json:"name,omitempty"`
	Description *string `json:"description,omitempty"`
}

// GuildFromTemplateCreate is the data used to create a Guild from a GuildTemplate
type GuildFromTemplateCreate struct {
	Name string `json:"name"`
	Icon *Icon  `json:"icon,omitempty"`
}
