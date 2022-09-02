package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

var _ Mentionable = (*Role)(nil)

// Role is a Guild Role object
type Role struct {
	ID          snowflake.ID `json:"id"`
	Name        string       `json:"name"`
	Color       int          `json:"color"`
	Hoist       bool         `json:"hoist"`
	Position    int          `json:"position"`
	Permissions Permissions  `json:"permissions"`
	Managed     bool         `json:"managed"`
	Icon        *string      `json:"icon"`
	Emoji       *string      `json:"unicode_emoji"`
	Mentionable bool         `json:"mentionable"`
	Tags        *RoleTag     `json:"tags,omitempty"`
}

func (r Role) String() string {
	return RoleMention(r.ID)
}

func (r Role) Mention() string {
	return r.String()
}

func (r Role) IconURL(opts ...CDNOpt) *string {
	if r.Icon == nil {
		return nil
	}
	url := formatAssetURL(RoleIcon, opts, r.ID, *r.Icon)
	return &url
}

func (r Role) CreatedAt() time.Time {
	return r.ID.Time()
}

// RoleTag are tags a Role has
type RoleTag struct {
	BotID             *snowflake.ID `json:"bot_id,omitempty"`
	IntegrationID     *snowflake.ID `json:"integration_id,omitempty"`
	PremiumSubscriber bool          `json:"premium_subscriber"`
}

// RoleCreate is the payload to create a Role
type RoleCreate struct {
	Name        string      `json:"name,omitempty"`
	Permissions Permissions `json:"permissions,omitempty"`
	Color       int         `json:"color,omitempty"`
	Hoist       bool        `json:"hoist,omitempty"`
	Icon        *Icon       `json:"icon,omitempty"`
	Emoji       *string     `json:"unicode_emoji,omitempty"`
	Mentionable bool        `json:"mentionable,omitempty"`
}

// RoleUpdate is the payload to update a Role
type RoleUpdate struct {
	Name        *string              `json:"name"`
	Permissions *Permissions         `json:"permissions"`
	Color       *int                 `json:"color"`
	Hoist       *bool                `json:"hoist"`
	Icon        *json.Nullable[Icon] `json:"icon,omitempty"`
	Emoji       *string              `json:"unicode_emoji,omitempty"`
	Mentionable *bool                `json:"mentionable"`
}

// RolePositionUpdate is the payload to update a Role(s) position
type RolePositionUpdate struct {
	ID       snowflake.ID `json:"id"`
	Position *int         `json:"position"`
}

// PartialRole holds basic info about a Role
type PartialRole struct {
	ID   snowflake.ID `json:"id"`
	Name string       `json:"name"`
}
