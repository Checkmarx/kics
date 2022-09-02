package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

type dmChannel struct {
	ID               snowflake.ID  `json:"id"`
	Type             ChannelType   `json:"type"`
	LastMessageID    *snowflake.ID `json:"last_message_id"`
	Recipients       []User        `json:"recipients"`
	LastPinTimestamp *time.Time    `json:"last_pin_timestamp"`
}

type guildTextChannel struct {
	ID                         snowflake.ID          `json:"id"`
	Type                       ChannelType           `json:"type"`
	GuildID                    snowflake.ID          `json:"guild_id"`
	Position                   int                   `json:"position"`
	PermissionOverwrites       []PermissionOverwrite `json:"permission_overwrites"`
	Name                       string                `json:"name"`
	Topic                      *string               `json:"topic"`
	NSFW                       bool                  `json:"nsfw"`
	LastMessageID              *snowflake.ID         `json:"last_message_id"`
	RateLimitPerUser           int                   `json:"rate_limit_per_user"`
	ParentID                   *snowflake.ID         `json:"parent_id"`
	LastPinTimestamp           *time.Time            `json:"last_pin_timestamp"`
	DefaultAutoArchiveDuration AutoArchiveDuration   `json:"default_auto_archive_duration"`
}

func (t *guildTextChannel) UnmarshalJSON(data []byte) error {
	type guildTextChannelAlias guildTextChannel
	var v struct {
		PermissionOverwrites []UnmarshalPermissionOverwrite `json:"permission_overwrites"`
		guildTextChannelAlias
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*t = guildTextChannel(v.guildTextChannelAlias)
	t.PermissionOverwrites = parsePermissionOverwrites(v.PermissionOverwrites)
	return nil
}

type guildNewsChannel struct {
	ID                         snowflake.ID          `json:"id"`
	Type                       ChannelType           `json:"type"`
	GuildID                    snowflake.ID          `json:"guild_id"`
	Position                   int                   `json:"position"`
	PermissionOverwrites       []PermissionOverwrite `json:"permission_overwrites"`
	Name                       string                `json:"name"`
	Topic                      *string               `json:"topic"`
	NSFW                       bool                  `json:"nsfw"`
	RateLimitPerUser           int                   `json:"rate_limit_per_user"`
	ParentID                   *snowflake.ID         `json:"parent_id"`
	LastMessageID              *snowflake.ID         `json:"last_message_id"`
	LastPinTimestamp           *time.Time            `json:"last_pin_timestamp"`
	DefaultAutoArchiveDuration AutoArchiveDuration   `json:"default_auto_archive_duration"`
}

func (t *guildNewsChannel) UnmarshalJSON(data []byte) error {
	type guildNewsChannelAlias guildNewsChannel
	var v struct {
		PermissionOverwrites []UnmarshalPermissionOverwrite `json:"permission_overwrites"`
		guildNewsChannelAlias
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*t = guildNewsChannel(v.guildNewsChannelAlias)
	t.PermissionOverwrites = parsePermissionOverwrites(v.PermissionOverwrites)
	return nil
}

type guildThread struct {
	ID               snowflake.ID   `json:"id"`
	Type             ChannelType    `json:"type"`
	GuildID          snowflake.ID   `json:"guild_id"`
	Name             string         `json:"name"`
	NSFW             bool           `json:"nsfw"`
	LastMessageID    *snowflake.ID  `json:"last_message_id"`
	RateLimitPerUser int            `json:"rate_limit_per_user"`
	OwnerID          snowflake.ID   `json:"owner_id"`
	ParentID         snowflake.ID   `json:"parent_id"`
	LastPinTimestamp *time.Time     `json:"last_pin_timestamp"`
	MessageCount     int            `json:"message_count"`
	TotalMessageSent int            `json:"total_message_sent"`
	MemberCount      int            `json:"member_count"`
	ThreadMetadata   ThreadMetadata `json:"thread_metadata"`
}

type guildCategoryChannel struct {
	ID                   snowflake.ID          `json:"id"`
	Type                 ChannelType           `json:"type"`
	GuildID              snowflake.ID          `json:"guild_id"`
	Position             int                   `json:"position"`
	PermissionOverwrites []PermissionOverwrite `json:"permission_overwrites"`
	Name                 string                `json:"name"`
}

func (t *guildCategoryChannel) UnmarshalJSON(data []byte) error {
	type guildCategoryChannelAlias guildCategoryChannel
	var v struct {
		PermissionOverwrites []UnmarshalPermissionOverwrite `json:"permission_overwrites"`
		guildCategoryChannelAlias
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*t = guildCategoryChannel(v.guildCategoryChannelAlias)
	t.PermissionOverwrites = parsePermissionOverwrites(v.PermissionOverwrites)
	return nil
}

type guildVoiceChannel struct {
	ID                         snowflake.ID          `json:"id"`
	Type                       ChannelType           `json:"type"`
	GuildID                    snowflake.ID          `json:"guild_id"`
	Position                   int                   `json:"position"`
	PermissionOverwrites       []PermissionOverwrite `json:"permission_overwrites"`
	Name                       string                `json:"name"`
	Bitrate                    int                   `json:"bitrate"`
	UserLimit                  int                   `json:"user_limit"`
	ParentID                   *snowflake.ID         `json:"parent_id"`
	RTCRegion                  string                `json:"rtc_region"`
	VideoQualityMode           VideoQualityMode      `json:"video_quality_mode"`
	LastMessageID              *snowflake.ID         `json:"last_message_id"`
	LastPinTimestamp           *time.Time            `json:"last_pin_timestamp"`
	Topic                      *string               `json:"topic"`
	NSFW                       bool                  `json:"nsfw"`
	DefaultAutoArchiveDuration AutoArchiveDuration   `json:"default_auto_archive_duration"`
	RateLimitPerUser           int                   `json:"rate_limit_per_user"`
}

func (t *guildVoiceChannel) UnmarshalJSON(data []byte) error {
	type guildVoiceChannelAlias guildVoiceChannel
	var v struct {
		PermissionOverwrites []UnmarshalPermissionOverwrite `json:"permission_overwrites"`
		guildVoiceChannelAlias
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*t = guildVoiceChannel(v.guildVoiceChannelAlias)
	t.PermissionOverwrites = parsePermissionOverwrites(v.PermissionOverwrites)
	return nil
}

type guildStageVoiceChannel struct {
	ID                   snowflake.ID          `json:"id"`
	Type                 ChannelType           `json:"type"`
	GuildID              snowflake.ID          `json:"guild_id"`
	Position             int                   `json:"position"`
	PermissionOverwrites []PermissionOverwrite `json:"permission_overwrites"`
	Name                 string                `json:"name"`
	Bitrate              int                   `json:"bitrate,"`
	ParentID             *snowflake.ID         `json:"parent_id"`
	RTCRegion            string                `json:"rtc_region"`
}

func (t *guildStageVoiceChannel) UnmarshalJSON(data []byte) error {
	type guildStageVoiceChannelAlias guildStageVoiceChannel
	var v struct {
		PermissionOverwrites []UnmarshalPermissionOverwrite `json:"permission_overwrites"`
		guildStageVoiceChannelAlias
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*t = guildStageVoiceChannel(v.guildStageVoiceChannelAlias)
	t.PermissionOverwrites = parsePermissionOverwrites(v.PermissionOverwrites)
	return nil
}

type guildForumChannel struct {
	ID                   snowflake.ID          `json:"id"`
	Type                 ChannelType           `json:"type"`
	GuildID              snowflake.ID          `json:"guild_id"`
	Position             int                   `json:"position"`
	PermissionOverwrites []PermissionOverwrite `json:"permission_overwrites"`
	Name                 string                `json:"name"`
	ParentID             *snowflake.ID         `json:"parent_id"`
	Topic                *string               `json:"topic"`
	RateLimitPerUser     int                   `json:"rate_limit_per_user"`

	// idk discord name your shit correctly
	LastThreadID *snowflake.ID `json:"last_message_id"`
}

func (t *guildForumChannel) UnmarshalJSON(data []byte) error {
	type guildForumChannelAlias guildForumChannel
	var v struct {
		PermissionOverwrites []UnmarshalPermissionOverwrite `json:"permission_overwrites"`
		guildForumChannelAlias
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*t = guildForumChannel(v.guildForumChannelAlias)
	t.PermissionOverwrites = parsePermissionOverwrites(v.PermissionOverwrites)
	return nil
}

func parsePermissionOverwrites(overwrites []UnmarshalPermissionOverwrite) []PermissionOverwrite {
	if len(overwrites) == 0 {
		return nil
	}
	permOverwrites := make([]PermissionOverwrite, len(overwrites))
	for i := range overwrites {
		permOverwrites[i] = overwrites[i].PermissionOverwrite
	}
	return permOverwrites
}
