package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Guilds = (*guildImpl)(nil)

func NewGuilds(client Client) Guilds {
	return &guildImpl{client: client}
}

type Guilds interface {
	GetGuild(guildID snowflake.ID, withCounts bool, opts ...RequestOpt) (*discord.RestGuild, error)
	GetGuildPreview(guildID snowflake.ID, opts ...RequestOpt) (*discord.GuildPreview, error)
	CreateGuild(guildCreate discord.GuildCreate, opts ...RequestOpt) (*discord.RestGuild, error)
	UpdateGuild(guildID snowflake.ID, guildUpdate discord.GuildUpdate, opts ...RequestOpt) (*discord.RestGuild, error)
	DeleteGuild(guildID snowflake.ID, opts ...RequestOpt) error

	CreateGuildChannel(guildID snowflake.ID, guildChannelCreate discord.GuildChannelCreate, opts ...RequestOpt) (discord.GuildChannel, error)
	GetGuildChannels(guildID snowflake.ID, opts ...RequestOpt) ([]discord.GuildChannel, error)
	UpdateChannelPositions(guildID snowflake.ID, guildChannelPositionUpdates []discord.GuildChannelPositionUpdate, opts ...RequestOpt) error

	GetRoles(guildID snowflake.ID, opts ...RequestOpt) ([]discord.Role, error)
	GetRole(guildID snowflake.ID, roleID snowflake.ID, opts ...RequestOpt) ([]discord.Role, error)
	CreateRole(guildID snowflake.ID, createRole discord.RoleCreate, opts ...RequestOpt) (*discord.Role, error)
	UpdateRole(guildID snowflake.ID, roleID snowflake.ID, roleUpdate discord.RoleUpdate, opts ...RequestOpt) (*discord.Role, error)
	UpdateRolePositions(guildID snowflake.ID, rolePositionUpdates []discord.RolePositionUpdate, opts ...RequestOpt) ([]discord.Role, error)
	DeleteRole(guildID snowflake.ID, roleID snowflake.ID, opts ...RequestOpt) error

	GetBans(guildID snowflake.ID, before snowflake.ID, after snowflake.ID, limit int, opts ...RequestOpt) ([]discord.Ban, error)
	GetBan(guildID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) (*discord.Ban, error)
	AddBan(guildID snowflake.ID, userID snowflake.ID, deleteMessageDays int, opts ...RequestOpt) error
	DeleteBan(guildID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) error

	GetIntegrations(guildID snowflake.ID, opts ...RequestOpt) ([]discord.Integration, error)
	DeleteIntegration(guildID snowflake.ID, integrationID snowflake.ID, opts ...RequestOpt) error

	GetAllWebhooks(guildID snowflake.ID, opts ...RequestOpt) ([]discord.Webhook, error)

	GetAuditLog(guildID snowflake.ID, userID snowflake.ID, actionType discord.AuditLogEvent, before snowflake.ID, limit int, opts ...RequestOpt) (*discord.AuditLog, error)
}

type guildImpl struct {
	client Client
}

func (s *guildImpl) GetGuild(guildID snowflake.ID, withCounts bool, opts ...RequestOpt) (guild *discord.RestGuild, err error) {
	values := discord.QueryValues{
		"with_counts": withCounts,
	}
	err = s.client.Do(GetGuild.Compile(values, guildID), nil, &guild, opts...)
	return
}

func (s *guildImpl) GetGuildPreview(guildID snowflake.ID, opts ...RequestOpt) (guildPreview *discord.GuildPreview, err error) {
	err = s.client.Do(GetGuildPreview.Compile(nil, guildID), nil, &guildPreview, opts...)
	return
}

func (s *guildImpl) CreateGuild(guildCreate discord.GuildCreate, opts ...RequestOpt) (guild *discord.RestGuild, err error) {
	err = s.client.Do(CreateGuild.Compile(nil), guildCreate, &guild, opts...)
	return
}

func (s *guildImpl) UpdateGuild(guildID snowflake.ID, guildUpdate discord.GuildUpdate, opts ...RequestOpt) (guild *discord.RestGuild, err error) {
	err = s.client.Do(UpdateGuild.Compile(nil, guildID), guildUpdate, &guild, opts...)
	return
}

func (s *guildImpl) DeleteGuild(guildID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteGuild.Compile(nil, guildID), nil, nil, opts...)
}

func (s *guildImpl) CreateGuildChannel(guildID snowflake.ID, guildChannelCreate discord.GuildChannelCreate, opts ...RequestOpt) (guildChannel discord.GuildChannel, err error) {
	var ch discord.UnmarshalChannel
	err = s.client.Do(CreateGuildChannel.Compile(nil, guildID), guildChannelCreate, &ch, opts...)
	if err == nil {
		guildChannel = ch.Channel.(discord.GuildChannel)
	}
	return
}

func (s *guildImpl) GetGuildChannels(guildID snowflake.ID, opts ...RequestOpt) (channels []discord.GuildChannel, err error) {
	var chs []discord.UnmarshalChannel
	err = s.client.Do(GetGuildChannels.Compile(nil, guildID), nil, &chs, opts...)
	if err == nil {
		channels = make([]discord.GuildChannel, len(chs))
		for i := range chs {
			channels[i] = chs[i].Channel.(discord.GuildChannel)
		}
	}
	return
}

func (s *guildImpl) UpdateChannelPositions(guildID snowflake.ID, guildChannelPositionUpdates []discord.GuildChannelPositionUpdate, opts ...RequestOpt) error {
	return s.client.Do(UpdateChannelPositions.Compile(nil, guildID), guildChannelPositionUpdates, nil, opts...)
}

func (s *guildImpl) GetRoles(guildID snowflake.ID, opts ...RequestOpt) (roles []discord.Role, err error) {
	err = s.client.Do(GetRoles.Compile(nil, guildID), nil, &roles, opts...)
	return
}

func (s *guildImpl) GetRole(guildID snowflake.ID, roleID snowflake.ID, opts ...RequestOpt) (role []discord.Role, err error) {
	err = s.client.Do(GetRole.Compile(nil, guildID, roleID), nil, &role, opts...)
	return
}

func (s *guildImpl) CreateRole(guildID snowflake.ID, createRole discord.RoleCreate, opts ...RequestOpt) (role *discord.Role, err error) {
	err = s.client.Do(CreateRole.Compile(nil, guildID), createRole, &role, opts...)
	return
}

func (s *guildImpl) UpdateRole(guildID snowflake.ID, roleID snowflake.ID, roleUpdate discord.RoleUpdate, opts ...RequestOpt) (role *discord.Role, err error) {
	err = s.client.Do(UpdateRole.Compile(nil, guildID, roleID), roleUpdate, &role, opts...)
	return
}

func (s *guildImpl) UpdateRolePositions(guildID snowflake.ID, rolePositionUpdates []discord.RolePositionUpdate, opts ...RequestOpt) (roles []discord.Role, err error) {
	err = s.client.Do(UpdateRolePositions.Compile(nil, guildID), rolePositionUpdates, &roles, opts...)
	return
}

func (s *guildImpl) DeleteRole(guildID snowflake.ID, roleID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteRole.Compile(nil, guildID, roleID), nil, nil, opts...)
}

func (s *guildImpl) GetBans(guildID snowflake.ID, before snowflake.ID, after snowflake.ID, limit int, opts ...RequestOpt) (bans []discord.Ban, err error) {
	values := discord.QueryValues{}
	if before != 0 {
		values["before"] = before
	}
	if after != 0 {
		values["after"] = after
	}
	if limit != 0 {
		values["limit"] = limit
	}
	err = s.client.Do(GetBans.Compile(values, guildID), nil, &bans, opts...)
	return
}

func (s *guildImpl) GetBan(guildID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) (ban *discord.Ban, err error) {
	err = s.client.Do(GetBan.Compile(nil, guildID, userID), nil, &ban, opts...)
	return
}

func (s *guildImpl) AddBan(guildID snowflake.ID, userID snowflake.ID, deleteMessageDays int, opts ...RequestOpt) error {
	return s.client.Do(AddBan.Compile(nil, guildID, userID), discord.AddBan{DeleteMessageDays: deleteMessageDays}, nil, opts...)
}

func (s *guildImpl) DeleteBan(guildID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteBan.Compile(nil, guildID, userID), nil, nil, opts...)
}

func (s *guildImpl) GetIntegrations(guildID snowflake.ID, opts ...RequestOpt) (integrations []discord.Integration, err error) {
	err = s.client.Do(GetIntegrations.Compile(nil, guildID), nil, &integrations, opts...)
	return
}

func (s *guildImpl) DeleteIntegration(guildID snowflake.ID, integrationID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteIntegration.Compile(nil, guildID, integrationID), nil, nil, opts...)
}

func (s *guildImpl) GetAllWebhooks(guildID snowflake.ID, opts ...RequestOpt) (webhooks []discord.Webhook, err error) {
	err = s.client.Do(GetGuildWebhooks.Compile(nil, guildID), nil, &webhooks, opts...)
	return
}

func (s *guildImpl) GetEmojis(guildID snowflake.ID, opts ...RequestOpt) (emojis []discord.Emoji, err error) {
	err = s.client.Do(GetEmojis.Compile(nil, guildID), nil, &emojis, opts...)
	return
}

func (s *guildImpl) GetAuditLog(guildID snowflake.ID, userID snowflake.ID, actionType discord.AuditLogEvent, before snowflake.ID, limit int, opts ...RequestOpt) (auditLog *discord.AuditLog, err error) {
	values := discord.QueryValues{}
	if userID != 0 {
		values["user_id"] = userID
	}
	if actionType != 0 {
		values["action_type"] = actionType
	}
	if before != 0 {
		values["before"] = guildID
	}
	if limit != 0 {
		values["limit"] = limit
	}
	err = s.client.Do(GetAuditLogs.Compile(values, guildID), nil, &auditLog, opts...)
	return
}
