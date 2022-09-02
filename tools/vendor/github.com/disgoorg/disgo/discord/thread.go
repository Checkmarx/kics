package discord

import "github.com/disgoorg/disgo/json"

type ThreadCreateFromMessage struct {
	Name                string              `json:"name"`
	AutoArchiveDuration AutoArchiveDuration `json:"auto_archive_duration,omitempty"`
}

type ForumThreadCreate struct {
	Name                string              `json:"name"`
	AutoArchiveDuration AutoArchiveDuration `json:"auto_archive_duration,omitempty"`
	RateLimitPerUser    int                 `json:"rate_limit_per_user,omitempty"`
	Message             MessageCreate       `json:"message"`
}

func (c ForumThreadCreate) ToBody() (any, error) {
	if len(c.Message.Files) > 0 {
		c.Message.Attachments = parseAttachments(c.Message.Files)
		return PayloadWithFiles(c, c.Message.Files...)
	}
	return c, nil
}

type ForumThread struct {
	GuildThread
	Message Message `json:"message"`
}

type ThreadCreate interface {
	json.Marshaler
	Type() ChannelType
}

type GuildNewsThreadCreate struct {
	Name                string              `json:"name"`
	AutoArchiveDuration AutoArchiveDuration `json:"auto_archive_duration,omitempty"`
}

func (c GuildNewsThreadCreate) MarshalJSON() ([]byte, error) {
	type guildNewsThreadCreate GuildNewsThreadCreate
	return json.Marshal(struct {
		Type ChannelType `json:"type"`
		guildNewsThreadCreate
	}{
		Type:                  c.Type(),
		guildNewsThreadCreate: guildNewsThreadCreate(c),
	})
}

func (GuildNewsThreadCreate) Type() ChannelType {
	return ChannelTypeGuildNewsThread
}

type GuildPublicThreadCreate struct {
	Name                string              `json:"name"`
	AutoArchiveDuration AutoArchiveDuration `json:"auto_archive_duration,omitempty"`
}

func (c GuildPublicThreadCreate) MarshalJSON() ([]byte, error) {
	type guildPublicThreadCreate GuildPublicThreadCreate
	return json.Marshal(struct {
		Type ChannelType `json:"type"`
		guildPublicThreadCreate
	}{
		Type:                    c.Type(),
		guildPublicThreadCreate: guildPublicThreadCreate(c),
	})
}

func (GuildPublicThreadCreate) Type() ChannelType {
	return ChannelTypeGuildPublicThread
}

type GuildPrivateThreadCreate struct {
	Name                string              `json:"name"`
	AutoArchiveDuration AutoArchiveDuration `json:"auto_archive_duration,omitempty"`
	Invitable           bool                `json:"invitable"`
}

func (c GuildPrivateThreadCreate) MarshalJSON() ([]byte, error) {
	type guildPrivateThreadCreate GuildPrivateThreadCreate
	return json.Marshal(struct {
		Type ChannelType `json:"type"`
		guildPrivateThreadCreate
	}{
		Type:                     c.Type(),
		guildPrivateThreadCreate: guildPrivateThreadCreate(c),
	})
}

func (GuildPrivateThreadCreate) Type() ChannelType {
	return ChannelTypeGuildPrivateThread
}

type GetThreads struct {
	Threads []GuildThread  `json:"threads"`
	Members []ThreadMember `json:"members"`
	HasMore bool           `json:"has_more"`
}

type GetAllThreads struct {
	Threads []GuildThread  `json:"threads"`
	Members []ThreadMember `json:"members"`
}
