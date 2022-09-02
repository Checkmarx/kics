package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Channels = (*channelImpl)(nil)

func NewChannels(client Client) Channels {
	return &channelImpl{client: client}
}

type Channels interface {
	GetChannel(channelID snowflake.ID, opts ...RequestOpt) (discord.Channel, error)
	UpdateChannel(channelID snowflake.ID, channelUpdate discord.ChannelUpdate, opts ...RequestOpt) (discord.Channel, error)
	DeleteChannel(channelID snowflake.ID, opts ...RequestOpt) error

	GetWebhooks(channelID snowflake.ID, opts ...RequestOpt) ([]discord.Webhook, error)
	CreateWebhook(channelID snowflake.ID, webhookCreate discord.WebhookCreate, opts ...RequestOpt) (*discord.IncomingWebhook, error)

	GetPermissionOverwrites(channelID snowflake.ID, opts ...RequestOpt) ([]discord.PermissionOverwrite, error)
	GetPermissionOverwrite(channelID snowflake.ID, overwriteID snowflake.ID, opts ...RequestOpt) (*discord.PermissionOverwrite, error)
	UpdatePermissionOverwrite(channelID snowflake.ID, overwriteID snowflake.ID, permissionOverwrite discord.PermissionOverwriteUpdate, opts ...RequestOpt) error
	DeletePermissionOverwrite(channelID snowflake.ID, overwriteID snowflake.ID, opts ...RequestOpt) error

	SendTyping(channelID snowflake.ID, opts ...RequestOpt) error

	GetMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) (*discord.Message, error)
	GetMessages(channelID snowflake.ID, around snowflake.ID, before snowflake.ID, after snowflake.ID, limit int, opts ...RequestOpt) ([]discord.Message, error)
	CreateMessage(channelID snowflake.ID, messageCreate discord.MessageCreate, opts ...RequestOpt) (*discord.Message, error)
	UpdateMessage(channelID snowflake.ID, messageID snowflake.ID, messageUpdate discord.MessageUpdate, opts ...RequestOpt) (*discord.Message, error)
	DeleteMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error
	BulkDeleteMessages(channelID snowflake.ID, messageIDs []snowflake.ID, opts ...RequestOpt) error
	CrosspostMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) (*discord.Message, error)

	GetReactions(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) ([]discord.User, error)
	AddReaction(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) error
	RemoveOwnReaction(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) error
	RemoveUserReaction(channelID snowflake.ID, messageID snowflake.ID, emoji string, userID snowflake.ID, opts ...RequestOpt) error
	RemoveAllReactions(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error
	RemoveAllReactionsForEmoji(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) error

	GetPinnedMessages(channelID snowflake.ID, opts ...RequestOpt) ([]discord.Message, error)
	PinMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error
	UnpinMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error
	// TODO: add missing endpoints
}

type channelImpl struct {
	client Client
}

func (s *channelImpl) GetChannel(channelID snowflake.ID, opts ...RequestOpt) (channel discord.Channel, err error) {
	var ch discord.UnmarshalChannel
	err = s.client.Do(GetChannel.Compile(nil, channelID), nil, &ch, opts...)
	if err == nil {
		channel = ch.Channel
	}
	return
}

func (s *channelImpl) UpdateChannel(channelID snowflake.ID, channelUpdate discord.ChannelUpdate, opts ...RequestOpt) (channel discord.Channel, err error) {
	var ch discord.UnmarshalChannel
	err = s.client.Do(UpdateChannel.Compile(nil, channelID), channelUpdate, &ch, opts...)
	if err == nil {
		channel = ch.Channel
	}
	return
}

func (s *channelImpl) DeleteChannel(channelID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteChannel.Compile(nil, channelID), nil, nil, opts...)
}

func (s *channelImpl) GetWebhooks(channelID snowflake.ID, opts ...RequestOpt) (webhooks []discord.Webhook, err error) {
	err = s.client.Do(GetChannelWebhooks.Compile(nil, channelID), nil, &webhooks, opts...)
	return
}

func (s *channelImpl) CreateWebhook(channelID snowflake.ID, webhookCreate discord.WebhookCreate, opts ...RequestOpt) (webhook *discord.IncomingWebhook, err error) {
	err = s.client.Do(CreateWebhook.Compile(nil, channelID), webhookCreate, &webhook, opts...)
	return
}

func (s *channelImpl) GetPermissionOverwrites(channelID snowflake.ID, opts ...RequestOpt) (overwrites []discord.PermissionOverwrite, err error) {
	err = s.client.Do(GetPermissionOverwrites.Compile(nil, channelID), nil, &overwrites, opts...)
	return
}

func (s *channelImpl) GetPermissionOverwrite(channelID snowflake.ID, overwriteID snowflake.ID, opts ...RequestOpt) (overwrite *discord.PermissionOverwrite, err error) {
	err = s.client.Do(GetPermissionOverwrite.Compile(nil, channelID, overwriteID), nil, &overwrite, opts...)
	return
}

func (s *channelImpl) UpdatePermissionOverwrite(channelID snowflake.ID, overwriteID snowflake.ID, permissionOverwrite discord.PermissionOverwriteUpdate, opts ...RequestOpt) error {
	return s.client.Do(UpdatePermissionOverwrite.Compile(nil, channelID, overwriteID), permissionOverwrite, nil, opts...)
}

func (s *channelImpl) DeletePermissionOverwrite(channelID snowflake.ID, overwriteID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeletePermissionOverwrite.Compile(nil, channelID, overwriteID), nil, nil, opts...)
}

func (s *channelImpl) SendTyping(channelID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(SendTyping.Compile(nil, channelID), nil, nil, opts...)
}

func (s *channelImpl) GetMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) (message *discord.Message, err error) {
	err = s.client.Do(GetMessage.Compile(nil, channelID, messageID), nil, &message, opts...)
	return
}

func (s *channelImpl) GetMessages(channelID snowflake.ID, around snowflake.ID, before snowflake.ID, after snowflake.ID, limit int, opts ...RequestOpt) (messages []discord.Message, err error) {
	values := discord.QueryValues{}
	if around != 0 {
		values["around"] = around
	}
	if before != 0 {
		values["before"] = before
	}
	if after != 0 {
		values["after"] = after
	}
	if limit != 0 {
		values["limit"] = limit
	}
	err = s.client.Do(GetMessages.Compile(values, channelID), nil, &messages, opts...)
	return
}

func (s *channelImpl) CreateMessage(channelID snowflake.ID, messageCreate discord.MessageCreate, opts ...RequestOpt) (message *discord.Message, err error) {
	body, err := messageCreate.ToBody()
	if err != nil {
		return
	}
	err = s.client.Do(CreateMessage.Compile(nil, channelID), body, &message, opts...)
	return
}

func (s *channelImpl) UpdateMessage(channelID snowflake.ID, messageID snowflake.ID, messageUpdate discord.MessageUpdate, opts ...RequestOpt) (message *discord.Message, err error) {
	body, err := messageUpdate.ToBody()
	if err != nil {
		return
	}
	err = s.client.Do(UpdateMessage.Compile(nil, channelID, messageID), body, &message, opts...)
	return
}

func (s *channelImpl) DeleteMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteMessage.Compile(nil, channelID, messageID), nil, nil, opts...)
}

func (s *channelImpl) BulkDeleteMessages(channelID snowflake.ID, messageIDs []snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(BulkDeleteMessages.Compile(nil, channelID), discord.MessageBulkDelete{Messages: messageIDs}, nil, opts...)
}

func (s *channelImpl) CrosspostMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) (message *discord.Message, err error) {
	err = s.client.Do(CrosspostMessage.Compile(nil, channelID, messageID), nil, &message, opts...)
	return
}

func (s *channelImpl) GetReactions(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) (users []discord.User, err error) {
	err = s.client.Do(GetReactions.Compile(nil, channelID, messageID, emoji), nil, &users, opts...)
	return
}

func (s *channelImpl) AddReaction(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) error {
	return s.client.Do(AddReaction.Compile(nil, channelID, messageID, emoji), nil, nil, opts...)
}

func (s *channelImpl) RemoveOwnReaction(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) error {
	return s.client.Do(RemoveOwnReaction.Compile(nil, channelID, messageID, emoji), nil, nil, opts...)
}

func (s *channelImpl) RemoveUserReaction(channelID snowflake.ID, messageID snowflake.ID, emoji string, userID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(RemoveUserReaction.Compile(nil, channelID, messageID, emoji, userID), nil, nil, opts...)
}

func (s *channelImpl) RemoveAllReactions(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(RemoveAllReactions.Compile(nil, channelID, messageID), nil, nil, opts...)
}

func (s *channelImpl) RemoveAllReactionsForEmoji(channelID snowflake.ID, messageID snowflake.ID, emoji string, opts ...RequestOpt) error {
	return s.client.Do(RemoveAllReactionsForEmoji.Compile(nil, channelID, messageID, emoji), nil, nil, opts...)
}

func (s *channelImpl) GetPinnedMessages(channelID snowflake.ID, opts ...RequestOpt) (messages []discord.Message, err error) {
	err = s.client.Do(GetPinnedMessages.Compile(nil, channelID), nil, &messages, opts...)
	return
}

func (s *channelImpl) PinMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(PinMessage.Compile(nil, channelID, messageID), nil, nil, opts...)
}

func (s *channelImpl) UnpinMessage(channelID snowflake.ID, messageID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(UnpinMessage.Compile(nil, channelID, messageID), nil, nil, opts...)
}

func (s *channelImpl) Follow(channelID snowflake.ID, targetChannelID snowflake.ID, opts ...RequestOpt) (followedChannel *discord.FollowedChannel, err error) {
	err = s.client.Do(FollowChannel.Compile(nil, channelID), discord.FollowChannel{ChannelID: targetChannelID}, &followedChannel, opts...)
	return
}
