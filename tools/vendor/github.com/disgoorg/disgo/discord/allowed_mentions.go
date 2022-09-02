package discord

import "github.com/disgoorg/snowflake/v2"

// DefaultAllowedMentions gives you the default AllowedMentions for a Message
var DefaultAllowedMentions = AllowedMentions{
	Parse:       []AllowedMentionType{AllowedMentionTypeUsers, AllowedMentionTypeRoles, AllowedMentionTypeEveryone},
	Roles:       []snowflake.ID{},
	Users:       []snowflake.ID{},
	RepliedUser: true,
}

// AllowedMentions are used for avoiding mentioning users in Message and Interaction
type AllowedMentions struct {
	Parse       []AllowedMentionType `json:"parse"`
	Roles       []snowflake.ID       `json:"roles"`
	Users       []snowflake.ID       `json:"users"`
	RepliedUser bool                 `json:"replied_user"`
}

// AllowedMentionType ?
type AllowedMentionType string

// All AllowedMentionType(s)
const (
	AllowedMentionTypeRoles    AllowedMentionType = "roles"
	AllowedMentionTypeUsers    AllowedMentionType = "users"
	AllowedMentionTypeEveryone AllowedMentionType = "everyone"
)
