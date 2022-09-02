package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ GuildTemplates = (*guildTemplateImpl)(nil)

func NewGuildTemplates(client Client) GuildTemplates {
	return &guildTemplateImpl{client: client}
}

type GuildTemplates interface {
	GetGuildTemplate(templateCode string, opts ...RequestOpt) (*discord.GuildTemplate, error)
	GetGuildTemplates(guildID snowflake.ID, opts ...RequestOpt) ([]discord.GuildTemplate, error)
	CreateGuildTemplate(guildID snowflake.ID, guildTemplateCreate discord.GuildTemplateCreate, opts ...RequestOpt) (*discord.GuildTemplate, error)
	CreateGuildFromTemplate(templateCode string, createGuildFromTemplate discord.GuildFromTemplateCreate, opts ...RequestOpt) (*discord.Guild, error)
	SyncGuildTemplate(guildID snowflake.ID, templateCode string, opts ...RequestOpt) (*discord.GuildTemplate, error)
	UpdateGuildTemplate(guildID snowflake.ID, templateCode string, guildTemplateUpdate discord.GuildTemplateUpdate, opts ...RequestOpt) (*discord.GuildTemplate, error)
	DeleteGuildTemplate(guildID snowflake.ID, templateCode string, opts ...RequestOpt) (*discord.GuildTemplate, error)
}

type guildTemplateImpl struct {
	client Client
}

func (s *guildTemplateImpl) GetGuildTemplate(templateCode string, opts ...RequestOpt) (guildTemplate *discord.GuildTemplate, err error) {
	err = s.client.Do(GetGuildTemplate.Compile(nil, templateCode), nil, &guildTemplate, opts...)
	return
}

func (s *guildTemplateImpl) GetGuildTemplates(guildID snowflake.ID, opts ...RequestOpt) (guildTemplates []discord.GuildTemplate, err error) {
	err = s.client.Do(GetGuildTemplates.Compile(nil, guildID), nil, &guildTemplates, opts...)
	return
}

func (s *guildTemplateImpl) CreateGuildTemplate(guildID snowflake.ID, guildTemplateCreate discord.GuildTemplateCreate, opts ...RequestOpt) (guildTemplate *discord.GuildTemplate, err error) {
	err = s.client.Do(CreateGuildTemplate.Compile(nil, guildID), guildTemplateCreate, &guildTemplate, opts...)
	return
}

func (s *guildTemplateImpl) CreateGuildFromTemplate(templateCode string, createGuildFromTemplate discord.GuildFromTemplateCreate, opts ...RequestOpt) (guild *discord.Guild, err error) {
	err = s.client.Do(CreateGuildFromTemplate.Compile(nil, templateCode), createGuildFromTemplate, &guild, opts...)
	return
}

func (s *guildTemplateImpl) SyncGuildTemplate(guildID snowflake.ID, templateCode string, opts ...RequestOpt) (guildTemplate *discord.GuildTemplate, err error) {
	err = s.client.Do(SyncGuildTemplate.Compile(nil, guildID, templateCode), nil, &guildTemplate, opts...)
	return
}

func (s *guildTemplateImpl) UpdateGuildTemplate(guildID snowflake.ID, templateCode string, guildTemplateUpdate discord.GuildTemplateUpdate, opts ...RequestOpt) (guildTemplate *discord.GuildTemplate, err error) {
	err = s.client.Do(UpdateGuildTemplate.Compile(nil, guildID, templateCode), guildTemplateUpdate, &guildTemplate, opts...)
	return
}

func (s *guildTemplateImpl) DeleteGuildTemplate(guildID snowflake.ID, templateCode string, opts ...RequestOpt) (guildTemplate *discord.GuildTemplate, err error) {
	err = s.client.Do(DeleteGuildTemplate.Compile(nil, guildID, templateCode), nil, &guildTemplate, opts...)
	return
}
