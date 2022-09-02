package discord

import (
	"fmt"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

// ApplicationCommandPermissionType is the type of the ApplicationCommandPermission
type ApplicationCommandPermissionType int

// types of ApplicationCommandPermissionType
const (
	ApplicationCommandPermissionTypeRole = iota + 1
	ApplicationCommandPermissionTypeUser
	ApplicationCommandPermissionTypeChannel
)

// ApplicationCommandPermissionsSet is used to bulk overwrite all ApplicationCommandPermissions
type ApplicationCommandPermissionsSet struct {
	ID          snowflake.ID                   `json:"id,omitempty"`
	Permissions []ApplicationCommandPermission `json:"permissions"`
}

// ApplicationCommandPermissions holds all permissions for an ApplicationCommand
type ApplicationCommandPermissions struct {
	ID            snowflake.ID                   `json:"id"`
	ApplicationID snowflake.ID                   `json:"application_id"`
	GuildID       snowflake.ID                   `json:"guild_id"`
	Permissions   []ApplicationCommandPermission `json:"permissions"`
}

func (p *ApplicationCommandPermissions) UnmarshalJSON(data []byte) error {
	type applicationCommandPermissions ApplicationCommandPermissions
	var v struct {
		Permissions []UnmarshalApplicationCommandPermission `json:"permissions"`
		applicationCommandPermissions
	}

	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*p = ApplicationCommandPermissions(v.applicationCommandPermissions)

	if len(v.Permissions) > 0 {
		p.Permissions = make([]ApplicationCommandPermission, len(v.Permissions))
		for i := range v.Permissions {
			p.Permissions[i] = v.Permissions[i].ApplicationCommandPermission
		}
	}
	return nil
}

type UnmarshalApplicationCommandPermission struct {
	ApplicationCommandPermission
}

func (p *UnmarshalApplicationCommandPermission) UnmarshalJSON(data []byte) error {
	var pType struct {
		Type ApplicationCommandPermissionType `json:"type"`
	}

	if err := json.Unmarshal(data, &pType); err != nil {
		return err
	}

	var (
		applicationCommandPermission ApplicationCommandPermission
		err                          error
	)

	switch pType.Type {
	case ApplicationCommandPermissionTypeRole:
		var v ApplicationCommandPermissionRole
		err = json.Unmarshal(data, &v)
		applicationCommandPermission = v

	case ApplicationCommandPermissionTypeUser:
		var v ApplicationCommandPermissionUser
		err = json.Unmarshal(data, &v)
		applicationCommandPermission = v

	case ApplicationCommandPermissionTypeChannel:
		var v ApplicationCommandPermissionChannel
		err = json.Unmarshal(data, &v)
		applicationCommandPermission = v

	default:
		err = fmt.Errorf("unkown application command permission with type %d received", pType.Type)
	}

	if err != nil {
		return err
	}

	p.ApplicationCommandPermission = applicationCommandPermission
	return nil
}

// ApplicationCommandPermission holds a User or Role and if they are allowed to use the ApplicationCommand
type ApplicationCommandPermission interface {
	json.Marshaler
	Type() ApplicationCommandPermissionType
	ID() snowflake.ID
	applicationCommandPermission()
}

type ApplicationCommandPermissionRole struct {
	RoleID     snowflake.ID `json:"id"`
	Permission bool         `json:"permission"`
}

func (p ApplicationCommandPermissionRole) MarshalJSON() ([]byte, error) {
	type applicationCommandPermissionRole ApplicationCommandPermissionRole
	return json.Marshal(struct {
		Type ApplicationCommandPermissionType `json:"type"`
		applicationCommandPermissionRole
	}{
		Type:                             p.Type(),
		applicationCommandPermissionRole: applicationCommandPermissionRole(p),
	})
}

func (ApplicationCommandPermissionRole) Type() ApplicationCommandPermissionType {
	return ApplicationCommandPermissionTypeRole
}
func (p ApplicationCommandPermissionRole) ID() snowflake.ID            { return p.RoleID }
func (ApplicationCommandPermissionRole) applicationCommandPermission() {}

type ApplicationCommandPermissionUser struct {
	UserID     snowflake.ID `json:"id"`
	Permission bool         `json:"permission"`
}

func (p ApplicationCommandPermissionUser) MarshalJSON() ([]byte, error) {
	type applicationCommandPermissionUser ApplicationCommandPermissionUser
	return json.Marshal(struct {
		Type ApplicationCommandPermissionType `json:"type"`
		applicationCommandPermissionUser
	}{
		Type:                             p.Type(),
		applicationCommandPermissionUser: applicationCommandPermissionUser(p),
	})
}

func (ApplicationCommandPermissionUser) Type() ApplicationCommandPermissionType {
	return ApplicationCommandPermissionTypeUser
}
func (p ApplicationCommandPermissionUser) ID() snowflake.ID            { return p.UserID }
func (ApplicationCommandPermissionUser) applicationCommandPermission() {}

func AllGuildChannels(guildID snowflake.ID) snowflake.ID {
	return snowflake.ID(uint64(guildID) - 1)
}

type ApplicationCommandPermissionChannel struct {
	ChannelID  snowflake.ID `json:"id"`
	Permission bool         `json:"permission"`
}

func (p ApplicationCommandPermissionChannel) MarshalJSON() ([]byte, error) {
	type applicationCommandPermissionChannel ApplicationCommandPermissionChannel
	return json.Marshal(struct {
		Type ApplicationCommandPermissionType `json:"type"`
		applicationCommandPermissionChannel
	}{
		Type:                                p.Type(),
		applicationCommandPermissionChannel: applicationCommandPermissionChannel(p),
	})
}

func (ApplicationCommandPermissionChannel) Type() ApplicationCommandPermissionType {
	return ApplicationCommandPermissionTypeChannel
}
func (p ApplicationCommandPermissionChannel) ID() snowflake.ID            { return p.ChannelID }
func (ApplicationCommandPermissionChannel) applicationCommandPermission() {}
