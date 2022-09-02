package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Invites = (*inviteImpl)(nil)

func NewInvites(client Client) Invites {
	return &inviteImpl{client: client}
}

type Invites interface {
	GetInvite(code string, opts ...RequestOpt) (*discord.Invite, error)
	CreateInvite(channelID snowflake.ID, inviteCreate discord.InviteCreate, opts ...RequestOpt) (*discord.Invite, error)
	DeleteInvite(code string, opts ...RequestOpt) (*discord.Invite, error)
	GetGuildInvites(guildID snowflake.ID, opts ...RequestOpt) ([]discord.Invite, error)
	GetChannelInvites(channelID snowflake.ID, opts ...RequestOpt) ([]discord.Invite, error)
}

type inviteImpl struct {
	client Client
}

func (s *inviteImpl) GetInvite(code string, opts ...RequestOpt) (invite *discord.Invite, err error) {
	err = s.client.Do(GetInvite.Compile(nil, code), nil, &invite, opts...)
	return
}

func (s *inviteImpl) CreateInvite(channelID snowflake.ID, inviteCreate discord.InviteCreate, opts ...RequestOpt) (invite *discord.Invite, err error) {
	err = s.client.Do(CreateInvite.Compile(nil, channelID), inviteCreate, &invite, opts...)
	return
}

func (s *inviteImpl) DeleteInvite(code string, opts ...RequestOpt) (invite *discord.Invite, err error) {
	err = s.client.Do(DeleteInvite.Compile(nil, code), nil, &invite, opts...)
	return
}

func (s *inviteImpl) GetGuildInvites(guildID snowflake.ID, opts ...RequestOpt) (invites []discord.Invite, err error) {
	err = s.client.Do(GetGuildInvites.Compile(nil, guildID), nil, &invites, opts...)
	return
}

func (s *inviteImpl) GetChannelInvites(channelID snowflake.ID, opts ...RequestOpt) (invites []discord.Invite, err error) {
	err = s.client.Do(GetChannelInvites.Compile(nil, channelID), nil, &invites, opts...)
	return
}
