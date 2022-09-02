package discord

import (
	"time"

	"github.com/disgoorg/snowflake/v2"
)

type AutoModerationEventType int

const (
	AutoModerationEventTypeMessageSend AutoModerationEventType = iota + 1
)

type AutoModerationTriggerType int

const (
	AutoModerationTriggerTypeKeyword AutoModerationTriggerType = iota + 1
	_
	AutoModerationTriggerTypeSpam
	AutoModerationTriggerTypeKeywordPresent
	AutoModerationTriggerTypeMentionSpam
)

type AutoModerationTriggerMetadata struct {
	KeywordFilter     []string                      `json:"keyword_filter"`
	Presets           []AutoModerationKeywordPreset `json:"presets"`
	AllowList         []string                      `json:"allow_list"`
	MentionTotalLimit int                           `json:"mention_total_limit"`
}

type AutoModerationKeywordPreset int

const (
	AutoModerationKeywordPresetProfanity AutoModerationKeywordPreset = iota + 1
	AutoModerationKeywordPresetSexualContent
	AutoModerationKeywordPresetSlurs
)

type AutoModerationActionType int

const (
	AutoModerationActionTypeBlockMessage AutoModerationActionType = iota + 1
	AutoModerationActionTypeSendAlertMessage
	AutoModerationActionTypeTimeout
)

type AutoModerationAction struct {
	Type     AutoModerationActionType      `json:"type"`
	Metadata *AutoModerationActionMetadata `json:"metadata,omitempty"`
}

type AutoModerationActionMetadata struct {
	ChannelID       snowflake.ID `json:"channel_id"`
	DurationSeconds int          `json:"duration_seconds"`
}

type AutoModerationRule struct {
	ID              snowflake.ID                  `json:"id"`
	GuildID         snowflake.ID                  `json:"guild_id"`
	Name            string                        `json:"name"`
	CreatorID       snowflake.ID                  `json:"creator_id"`
	EventType       AutoModerationEventType       `json:"event_type"`
	TriggerType     AutoModerationTriggerType     `json:"trigger_type"`
	TriggerMetadata AutoModerationTriggerMetadata `json:"trigger_metadata"`
	Actions         []AutoModerationAction        `json:"actions"`
	Enabled         bool                          `json:"enabled"`
	ExemptRoles     []snowflake.ID                `json:"exempt_roles"`
	ExemptChannels  []snowflake.ID                `json:"exempt_channels"`
}

func (r AutoModerationRule) CreatedAt() time.Time {
	return r.ID.Time()
}

type AutoModerationRuleCreate struct {
	Name            string                         `json:"name"`
	EventType       AutoModerationEventType        `json:"event_type"`
	TriggerType     AutoModerationTriggerType      `json:"trigger_type"`
	TriggerMetadata *AutoModerationTriggerMetadata `json:"trigger_metadata,omitempty"`
	Actions         []AutoModerationAction         `json:"actions"`
	Enabled         bool                           `json:"enabled,omitempty"`
	ExemptRoles     []snowflake.ID                 `json:"exempt_roles,omitempty"`
	ExemptChannels  []snowflake.ID                 `json:"exempt_channels,omitempty"`
}

type AutoModerationRuleUpdate struct {
	Name            *string                        `json:"name,omitempty"`
	EventType       *AutoModerationEventType       `json:"event_type,omitempty"`
	TriggerMetadata *AutoModerationTriggerMetadata `json:"trigger_metadata,omitempty"`
	Actions         *[]AutoModerationAction        `json:"actions,omitempty"`
	Enabled         *bool                          `json:"enabled,omitempty"`
	ExemptRoles     *[]snowflake.ID                `json:"exempt_roles,omitempty"`
	ExemptChannels  *[]snowflake.ID                `json:"exempt_channels,omitempty"`
}
