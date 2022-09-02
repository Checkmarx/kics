package discord

import (
	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

type ChannelUpdate interface {
	channelUpdate()
}

type GuildChannelUpdate interface {
	ChannelUpdate
	guildChannelUpdate()
}

type GuildTextChannelUpdate struct {
	Name                       *string                `json:"name,omitempty"`
	Type                       *ChannelType           `json:"type,omitempty"`
	Position                   *int                   `json:"position,omitempty"`
	Topic                      *string                `json:"topic,omitempty"`
	NSFW                       *bool                  `json:"nsfw,omitempty"`
	RateLimitPerUser           *int                   `json:"rate_limit_per_user,omitempty"`
	PermissionOverwrites       *[]PermissionOverwrite `json:"permission_overwrites,omitempty"`
	ParentID                   *snowflake.ID          `json:"parent_id,omitempty"`
	DefaultAutoArchiveDuration *AutoArchiveDuration   `json:"default_auto_archive_duration,omitempty"`
}

func (GuildTextChannelUpdate) channelUpdate()      {}
func (GuildTextChannelUpdate) guildChannelUpdate() {}

type GuildVoiceChannelUpdate struct {
	Name                 *string                `json:"name,omitempty"`
	Position             *int                   `json:"position,omitempty"`
	RateLimitPerUser     *int                   `json:"rate_limit_per_user,omitempty"`
	Bitrate              *int                   `json:"bitrate,omitempty"`
	UserLimit            *int                   `json:"user_limit,omitempty"`
	PermissionOverwrites *[]PermissionOverwrite `json:"permission_overwrites,omitempty"`
	ParentID             *snowflake.ID          `json:"parent_id,omitempty"`
	RTCRegion            *string                `json:"rtc_region"`
	VideoQualityMode     *VideoQualityMode      `json:"video_quality_mode"`
}

func (GuildVoiceChannelUpdate) channelUpdate()      {}
func (GuildVoiceChannelUpdate) guildChannelUpdate() {}

type GuildCategoryChannelUpdate struct {
	Name                 *string                `json:"name,omitempty"`
	Position             *int                   `json:"position,omitempty"`
	PermissionOverwrites *[]PermissionOverwrite `json:"permission_overwrites,omitempty"`
}

func (GuildCategoryChannelUpdate) channelUpdate()      {}
func (GuildCategoryChannelUpdate) guildChannelUpdate() {}

type GuildNewsChannelUpdate struct {
	Name                       *string                `json:"name,omitempty"`
	Type                       *ChannelType           `json:"type,omitempty"`
	Position                   *int                   `json:"position,omitempty"`
	Topic                      *string                `json:"topic,omitempty"`
	RateLimitPerUser           *int                   `json:"rate_limit_per_user,omitempty"`
	PermissionOverwrites       *[]PermissionOverwrite `json:"permission_overwrites,omitempty"`
	ParentID                   *snowflake.ID          `json:"parent_id,omitempty"`
	DefaultAutoArchiveDuration *int                   `json:"default_auto_archive_duration"`
}

func (GuildNewsChannelUpdate) channelUpdate()      {}
func (GuildNewsChannelUpdate) guildChannelUpdate() {}

type GuildThreadUpdate struct {
	Name                *string              `json:"name,omitempty"`
	Archived            *bool                `json:"archived,omitempty"`
	AutoArchiveDuration *AutoArchiveDuration `json:"auto_archive_duration,omitempty"`
	Locked              *bool                `json:"locked,omitempty"`
	Invitable           *bool                `json:"invitable,omitempty"`
	RateLimitPerUser    *int                 `json:"rate_limit_per_user,omitempty"`
}

func (GuildThreadUpdate) channelUpdate()      {}
func (GuildThreadUpdate) guildChannelUpdate() {}

type GuildStageVoiceChannelUpdate struct {
	Name                 *string                `json:"name,omitempty"`
	Position             *int                   `json:"position,omitempty"`
	Topic                *string                `json:"topic,omitempty"`
	Bitrate              *int                   `json:"bitrate,omitempty"`
	UserLimit            *int                   `json:"user_limit,omitempty"`
	PermissionOverwrites *[]PermissionOverwrite `json:"permission_overwrites,omitempty"`
	ParentID             *snowflake.ID          `json:"parent_id,omitempty"`
	RTCRegion            *string                `json:"rtc_region"`
}

func (GuildStageVoiceChannelUpdate) channelUpdate()      {}
func (GuildStageVoiceChannelUpdate) guildChannelUpdate() {}

type GuildForumChannelUpdate struct {
	Name                 *string                `json:"name,omitempty"`
	Position             *int                   `json:"position,omitempty"`
	Topic                *string                `json:"topic,omitempty"`
	PermissionOverwrites *[]PermissionOverwrite `json:"permission_overwrites,omitempty"`
	ParentID             *snowflake.ID          `json:"parent_id,omitempty"`
	RateLimitPerUser     *int                   `json:"rate_limit_per_user"`
}

func (GuildForumChannelUpdate) channelUpdate()      {}
func (GuildForumChannelUpdate) guildChannelUpdate() {}

type GuildChannelPositionUpdate struct {
	ID              snowflake.ID                 `json:"id"`
	Position        *json.Nullable[int]          `json:"position"`
	LockPermissions *json.Nullable[bool]         `json:"lock_permissions,omitempty"`
	ParentID        *json.Nullable[snowflake.ID] `json:"parent_id,omitempty"`
}
