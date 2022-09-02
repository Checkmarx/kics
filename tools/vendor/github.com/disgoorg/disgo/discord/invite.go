package discord

import (
	"time"

	"github.com/disgoorg/snowflake/v2"
)

// InviteTargetType is type of target an Invite uses
type InviteTargetType int

// Constants for TargetType
const (
	InviteTargetTypeStream InviteTargetType = iota + 1
	InviteTargetTypeEmbeddedApplication
)

// Invite is a partial invite struct
type Invite struct {
	Code                     string               `json:"code"`
	Guild                    *InviteGuild         `json:"guild"`
	Channel                  *InviteChannel       `json:"channel"`
	ChannelID                snowflake.ID         `json:"channel_id"`
	Inviter                  *User                `json:"inviter"`
	TargetUser               *User                `json:"target_user"`
	TargetType               InviteTargetType     `json:"target_user_type"`
	ApproximatePresenceCount int                  `json:"approximate_presence_count"`
	ApproximateMemberCount   int                  `json:"approximate_member_count"`
	ExpiresAt                *time.Time           `json:"created_at"`
	GuildScheduledEvent      *GuildScheduledEvent `json:"guild_scheduled_event"`
}

func (i Invite) URL() string {
	return InviteURL(i.Code)
}

type ExtendedInvite struct {
	Invite
	Uses      int       `json:"uses"`
	MaxUses   int       `json:"max_uses"`
	MaxAge    int       `json:"max_age"`
	Temporary bool      `json:"temporary"`
	CreatedAt time.Time `json:"created_at"`
}

type InviteChannel struct {
	ID   snowflake.ID `json:"id"`
	Type ChannelType  `json:"type"`
	Name string       `json:"name"`
	Icon *string      `json:"icon,omitempty"`
}

// IconURL returns the Icon URL of this channel.
// This will be nil for every ChannelType except ChannelTypeGroupDM
func (c InviteChannel) IconURL(opts ...CDNOpt) *string {
	if c.Icon == nil {
		return nil
	}
	url := formatAssetURL(ChannelIcon, opts, c.ID, *c.Icon)
	return &url
}

// An InviteGuild is the Guild of an Invite
type InviteGuild struct {
	ID                snowflake.ID      `json:"id"`
	Name              string            `json:"name"`
	Splash            *string           `json:"splash"`
	Banner            *string           `json:"banner"`
	Description       *string           `json:"description"`
	Icon              *string           `json:"icon"`
	Features          []GuildFeature    `json:"features"`
	VerificationLevel VerificationLevel `json:"verification_level"`
	VanityURLCode     *string           `json:"vanity_url_code"`
}

type InviteCreate struct {
	MaxAgree            int              `json:"max_agree,omitempty"`
	MaxUses             int              `json:"max_uses,omitempty"`
	Temporary           bool             `json:"temporary,omitempty"`
	Unique              bool             `json:"unique,omitempty"`
	TargetType          InviteTargetType `json:"target_type,omitempty"`
	TargetUserID        snowflake.ID     `json:"target_user_id,omitempty"`
	TargetApplicationID snowflake.ID     `json:"target_application_id,omitempty"`
}
