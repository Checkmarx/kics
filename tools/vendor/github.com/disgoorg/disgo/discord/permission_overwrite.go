package discord

import (
	"fmt"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

// PermissionOverwriteType is the type of PermissionOverwrite
type PermissionOverwriteType int

// Constants for PermissionOverwriteType
const (
	PermissionOverwriteTypeRole PermissionOverwriteType = iota
	PermissionOverwriteTypeMember
)

type PermissionOverwrites []PermissionOverwrite

func (p PermissionOverwrites) Get(overwriteType PermissionOverwriteType, id snowflake.ID) (PermissionOverwrite, bool) {
	for _, v := range p {
		if v.Type() == overwriteType && v.ID() == id {
			return v, true
		}
	}
	return nil, false
}

func (p PermissionOverwrites) Role(id snowflake.ID) (RolePermissionOverwrite, bool) {
	if overwrite, ok := p.Get(PermissionOverwriteTypeRole, id); ok {
		return overwrite.(RolePermissionOverwrite), true
	}
	return RolePermissionOverwrite{}, false
}

func (p PermissionOverwrites) Member(id snowflake.ID) (MemberPermissionOverwrite, bool) {
	if overwrite, ok := p.Get(PermissionOverwriteTypeMember, id); ok {
		return overwrite.(MemberPermissionOverwrite), true
	}
	return MemberPermissionOverwrite{}, false
}

// PermissionOverwrite is used to determine who can perform particular actions in a GetGuildChannel
type PermissionOverwrite interface {
	Type() PermissionOverwriteType
	ID() snowflake.ID
}

type UnmarshalPermissionOverwrite struct {
	PermissionOverwrite
}

func (o *UnmarshalPermissionOverwrite) UnmarshalJSON(data []byte) error {
	var oType struct {
		Type PermissionOverwriteType `json:"type"`
	}

	if err := json.Unmarshal(data, &oType); err != nil {
		return err
	}

	var (
		overwrite PermissionOverwrite
		err       error
	)

	switch oType.Type {
	case PermissionOverwriteTypeRole:
		var v RolePermissionOverwrite
		err = json.Unmarshal(data, &v)
		overwrite = v

	case PermissionOverwriteTypeMember:
		var v MemberPermissionOverwrite
		err = json.Unmarshal(data, &v)
		overwrite = v

	default:
		err = fmt.Errorf("unkown permission overwrite with type %d received", oType.Type)
	}

	if err != nil {
		return err
	}

	o.PermissionOverwrite = overwrite
	return nil
}

type RolePermissionOverwrite struct {
	RoleID snowflake.ID `json:"id"`
	Allow  Permissions  `json:"allow"`
	Deny   Permissions  `json:"deny"`
}

func (o RolePermissionOverwrite) ID() snowflake.ID {
	return o.RoleID
}

func (o RolePermissionOverwrite) MarshalJSON() ([]byte, error) {
	type rolePermissionOverwrite RolePermissionOverwrite
	return json.Marshal(struct {
		Type PermissionOverwriteType `json:"type"`
		rolePermissionOverwrite
	}{
		Type:                    o.Type(),
		rolePermissionOverwrite: rolePermissionOverwrite(o),
	})
}

func (o RolePermissionOverwrite) Type() PermissionOverwriteType {
	return PermissionOverwriteTypeRole
}

type MemberPermissionOverwrite struct {
	UserID snowflake.ID `json:"id"`
	Allow  Permissions  `json:"allow"`
	Deny   Permissions  `json:"deny"`
}

func (o MemberPermissionOverwrite) ID() snowflake.ID {
	return o.UserID
}

func (o MemberPermissionOverwrite) MarshalJSON() ([]byte, error) {
	type memberPermissionOverwrite MemberPermissionOverwrite
	return json.Marshal(struct {
		Type PermissionOverwriteType `json:"type"`
		memberPermissionOverwrite
	}{
		Type:                      o.Type(),
		memberPermissionOverwrite: memberPermissionOverwrite(o),
	})
}

func (o MemberPermissionOverwrite) Type() PermissionOverwriteType {
	return PermissionOverwriteTypeMember
}

type PermissionOverwriteUpdate interface {
	Type() PermissionOverwriteType
}

type RolePermissionOverwriteUpdate struct {
	Allow Permissions `json:"allow"`
	Deny  Permissions `json:"deny"`
}

func (u RolePermissionOverwriteUpdate) MarshalJSON() ([]byte, error) {
	type rolePermissionOverwriteUpdate RolePermissionOverwriteUpdate
	return json.Marshal(struct {
		Type PermissionOverwriteType `json:"type"`
		rolePermissionOverwriteUpdate
	}{
		Type:                          u.Type(),
		rolePermissionOverwriteUpdate: rolePermissionOverwriteUpdate(u),
	})
}

func (RolePermissionOverwriteUpdate) Type() PermissionOverwriteType {
	return PermissionOverwriteTypeRole
}

type MemberPermissionOverwriteUpdate struct {
	Allow Permissions `json:"allow"`
	Deny  Permissions `json:"deny"`
}

func (u MemberPermissionOverwriteUpdate) MarshalJSON() ([]byte, error) {
	type memberPermissionOverwriteUpdate MemberPermissionOverwriteUpdate
	return json.Marshal(struct {
		Type PermissionOverwriteType `json:"type"`
		memberPermissionOverwriteUpdate
	}{
		Type:                            u.Type(),
		memberPermissionOverwriteUpdate: memberPermissionOverwriteUpdate(u),
	})
}

func (MemberPermissionOverwriteUpdate) Type() PermissionOverwriteType {
	return PermissionOverwriteTypeMember
}
