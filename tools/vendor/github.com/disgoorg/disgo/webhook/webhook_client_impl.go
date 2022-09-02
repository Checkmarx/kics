package webhook

import (
	"context"

	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/disgo/rest"
	"github.com/disgoorg/snowflake/v2"
)

// New creates a new Client with the given ID, token and ConfigOpt(s).
func New(id snowflake.ID, token string, opts ...ConfigOpt) Client {
	config := DefaultConfig()
	config.Apply(opts)

	return &clientImpl{
		id:     id,
		token:  token,
		config: *config,
	}
}

type clientImpl struct {
	id     snowflake.ID
	token  string
	config Config
}

func (c *clientImpl) ID() snowflake.ID {
	return c.id
}

func (c *clientImpl) Token() string {
	return c.token
}

func (c *clientImpl) URL() string {
	return discord.WebhookURL(c.id, c.token)
}

func (c *clientImpl) Close(ctx context.Context) {
	c.config.RestClient.Close(ctx)
}

func (c *clientImpl) Rest() rest.Webhooks {
	return c.config.Webhooks
}

func (c *clientImpl) GetWebhook(opts ...rest.RequestOpt) (*discord.IncomingWebhook, error) {
	webhook, err := c.Rest().GetWebhookWithToken(c.id, c.token, opts...)
	if incomingWebhook, ok := webhook.(discord.IncomingWebhook); ok && err == nil {
		return &incomingWebhook, nil
	}
	return nil, err
}

func (c *clientImpl) UpdateWebhook(webhookUpdate discord.WebhookUpdateWithToken, opts ...rest.RequestOpt) (*discord.IncomingWebhook, error) {
	webhook, err := c.Rest().UpdateWebhookWithToken(c.id, c.token, webhookUpdate, opts...)
	if incomingWebhook, ok := webhook.(discord.IncomingWebhook); ok && err == nil {
		return &incomingWebhook, nil
	}
	return nil, err
}

func (c *clientImpl) DeleteWebhook(opts ...rest.RequestOpt) error {
	return c.Rest().DeleteWebhookWithToken(c.id, c.token, opts...)
}

func (c *clientImpl) CreateMessageInThread(messageCreate discord.WebhookMessageCreate, threadID snowflake.ID, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.Rest().CreateWebhookMessage(c.id, c.token, messageCreate, true, threadID, opts...)
}

func (c *clientImpl) CreateMessage(messageCreate discord.WebhookMessageCreate, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.CreateMessageInThread(messageCreate, 0, opts...)
}

func (c *clientImpl) CreateContent(content string, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.CreateMessage(discord.WebhookMessageCreate{Content: content}, opts...)
}

func (c *clientImpl) CreateEmbeds(embeds []discord.Embed, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.CreateMessage(discord.WebhookMessageCreate{Embeds: embeds}, opts...)
}

func (c *clientImpl) UpdateMessage(messageID snowflake.ID, messageUpdate discord.WebhookMessageUpdate, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.UpdateMessageInThread(messageID, messageUpdate, 0, opts...)
}

func (c *clientImpl) UpdateMessageInThread(messageID snowflake.ID, messageUpdate discord.WebhookMessageUpdate, threadID snowflake.ID, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.Rest().UpdateWebhookMessage(c.id, c.token, messageID, messageUpdate, threadID, opts...)
}

func (c *clientImpl) UpdateContent(messageID snowflake.ID, content string, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.UpdateMessage(messageID, discord.WebhookMessageUpdate{Content: &content}, opts...)
}

func (c *clientImpl) UpdateEmbeds(messageID snowflake.ID, embeds []discord.Embed, opts ...rest.RequestOpt) (*discord.Message, error) {
	return c.UpdateMessage(messageID, discord.WebhookMessageUpdate{Embeds: &embeds}, opts...)
}

func (c *clientImpl) DeleteMessage(messageID snowflake.ID, opts ...rest.RequestOpt) error {
	return c.DeleteMessageInThread(messageID, 0, opts...)
}

func (c *clientImpl) DeleteMessageInThread(messageID snowflake.ID, threadID snowflake.ID, opts ...rest.RequestOpt) error {
	return c.Rest().DeleteWebhookMessage(c.id, c.token, messageID, threadID, opts...)
}
