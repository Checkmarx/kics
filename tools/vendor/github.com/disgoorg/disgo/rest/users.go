package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Users = (*userImpl)(nil)

func NewUsers(client Client) Users {
	return &userImpl{client: client}
}

type Users interface {
	GetUser(userID snowflake.ID, opts ...RequestOpt) (*discord.User, error)
	UpdateSelfUser(selfUserUpdate discord.SelfUserUpdate, opts ...RequestOpt) (*discord.OAuth2User, error)
	GetGuilds(before int, after int, limit int, opts ...RequestOpt) ([]discord.OAuth2Guild, error)
	LeaveGuild(guildID snowflake.ID, opts ...RequestOpt) error
	GetDMChannels(opts ...RequestOpt) ([]discord.Channel, error)
	CreateDMChannel(userID snowflake.ID, opts ...RequestOpt) (*discord.DMChannel, error)
}

type userImpl struct {
	client Client
}

func (s *userImpl) GetUser(userID snowflake.ID, opts ...RequestOpt) (user *discord.User, err error) {
	err = s.client.Do(GetUser.Compile(nil, userID), nil, &user, opts...)
	return
}

func (s *userImpl) UpdateSelfUser(updateSelfUser discord.SelfUserUpdate, opts ...RequestOpt) (selfUser *discord.OAuth2User, err error) {
	err = s.client.Do(UpdateSelfUser.Compile(nil), updateSelfUser, &selfUser, opts...)
	return
}

func (s *userImpl) GetGuilds(before int, after int, limit int, opts ...RequestOpt) (guilds []discord.OAuth2Guild, err error) {
	queryParams := discord.QueryValues{}
	if before > 0 {
		queryParams["before"] = before
	}
	if after > 0 {
		queryParams["after"] = after
	}
	if limit > 0 {
		queryParams["limit"] = limit
	}
	err = s.client.Do(GetCurrentUserGuilds.Compile(queryParams), nil, &guilds, opts...)
	return
}

func (s *userImpl) LeaveGuild(guildID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(LeaveGuild.Compile(nil, guildID), nil, nil, opts...)
}

func (s *userImpl) GetDMChannels(opts ...RequestOpt) (channels []discord.Channel, err error) {
	err = s.client.Do(GetDMChannels.Compile(nil), nil, &channels, opts...)
	return
}

func (s *userImpl) CreateDMChannel(userID snowflake.ID, opts ...RequestOpt) (channel *discord.DMChannel, err error) {
	err = s.client.Do(CreateDMChannel.Compile(nil), discord.DMChannelCreate{RecipientID: userID}, &channel, opts...)
	return
}
