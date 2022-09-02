package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Webhooks = (*webhookImpl)(nil)

func NewWebhooks(client Client) Webhooks {
	return &webhookImpl{client: client}
}

type Webhooks interface {
	GetWebhook(webhookID snowflake.ID, opts ...RequestOpt) (discord.Webhook, error)
	UpdateWebhook(webhookID snowflake.ID, webhookUpdate discord.WebhookUpdate, opts ...RequestOpt) (discord.Webhook, error)
	DeleteWebhook(webhookID snowflake.ID, opts ...RequestOpt) error

	GetWebhookWithToken(webhookID snowflake.ID, webhookToken string, opts ...RequestOpt) (discord.Webhook, error)
	UpdateWebhookWithToken(webhookID snowflake.ID, webhookToken string, webhookUpdate discord.WebhookUpdateWithToken, opts ...RequestOpt) (discord.Webhook, error)
	DeleteWebhookWithToken(webhookID snowflake.ID, webhookToken string, opts ...RequestOpt) error

	CreateWebhookMessage(webhookID snowflake.ID, webhookToken string, messageCreate discord.WebhookMessageCreate, wait bool, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error)
	CreateWebhookMessageSlack(webhookID snowflake.ID, webhookToken string, messageCreate discord.Payload, wait bool, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error)
	CreateWebhookMessageGitHub(webhookID snowflake.ID, webhookToken string, messageCreate discord.Payload, wait bool, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error)
	UpdateWebhookMessage(webhookID snowflake.ID, webhookToken string, messageID snowflake.ID, messageUpdate discord.WebhookMessageUpdate, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error)
	DeleteWebhookMessage(webhookID snowflake.ID, webhookToken string, messageID snowflake.ID, threadID snowflake.ID, opts ...RequestOpt) error
}

type webhookImpl struct {
	client Client
}

func (s *webhookImpl) GetWebhook(webhookID snowflake.ID, opts ...RequestOpt) (webhook discord.Webhook, err error) {
	var unmarshalWebhook discord.UnmarshalWebhook
	err = s.client.Do(GetWebhook.Compile(nil, webhookID), nil, &unmarshalWebhook, opts...)
	if err == nil {
		webhook = unmarshalWebhook.Webhook
	}
	return
}

func (s *webhookImpl) UpdateWebhook(webhookID snowflake.ID, webhookUpdate discord.WebhookUpdate, opts ...RequestOpt) (webhook discord.Webhook, err error) {
	var unmarshalWebhook discord.UnmarshalWebhook
	err = s.client.Do(UpdateWebhook.Compile(nil, webhookID), webhookUpdate, &unmarshalWebhook, opts...)
	if err == nil {
		webhook = unmarshalWebhook.Webhook
	}
	return
}

func (s *webhookImpl) DeleteWebhook(webhookID snowflake.ID, opts ...RequestOpt) (err error) {
	err = s.client.Do(DeleteWebhook.Compile(nil, webhookID), nil, nil, opts...)
	return
}

func (s *webhookImpl) GetWebhookWithToken(webhookID snowflake.ID, webhookToken string, opts ...RequestOpt) (webhook discord.Webhook, err error) {
	var unmarshalWebhook discord.UnmarshalWebhook
	err = s.client.Do(GetWebhookWithToken.Compile(nil, webhookID, webhookToken), nil, &unmarshalWebhook, opts...)
	if err == nil {
		webhook = unmarshalWebhook.Webhook
	}
	return
}

func (s *webhookImpl) UpdateWebhookWithToken(webhookID snowflake.ID, webhookToken string, webhookUpdate discord.WebhookUpdateWithToken, opts ...RequestOpt) (webhook discord.Webhook, err error) {
	var unmarshalWebhook discord.UnmarshalWebhook
	err = s.client.Do(UpdateWebhookWithToken.Compile(nil, webhookID, webhookToken), webhookUpdate, &unmarshalWebhook, opts...)
	if err == nil {
		webhook = unmarshalWebhook.Webhook
	}
	return
}

func (s *webhookImpl) DeleteWebhookWithToken(webhookID snowflake.ID, webhookToken string, opts ...RequestOpt) (err error) {
	err = s.client.Do(DeleteWebhookWithToken.Compile(nil, webhookID, webhookToken), nil, nil, opts...)
	return
}

func (s *webhookImpl) createWebhookMessage(webhookID snowflake.ID, webhookToken string, messageCreate discord.Payload, wait bool, threadID snowflake.ID, endpoint *Endpoint, opts []RequestOpt) (message *discord.Message, err error) {
	params := discord.QueryValues{}
	if wait {
		params["wait"] = true
	}
	if threadID != 0 {
		params["thread_id"] = threadID
	}
	compiledEndpoint := endpoint.Compile(params, webhookID, webhookToken)

	body, err := messageCreate.ToBody()
	if err != nil {
		return
	}

	if wait {
		err = s.client.Do(compiledEndpoint, body, &message, opts...)
	} else {
		err = s.client.Do(compiledEndpoint, body, nil, opts...)
	}
	return
}

func (s *webhookImpl) CreateWebhookMessage(webhookID snowflake.ID, webhookToken string, messageCreate discord.WebhookMessageCreate, wait bool, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error) {
	return s.createWebhookMessage(webhookID, webhookToken, messageCreate, wait, threadID, CreateWebhookMessage, opts)
}

func (s *webhookImpl) CreateWebhookMessageSlack(webhookID snowflake.ID, webhookToken string, messageCreate discord.Payload, wait bool, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error) {
	return s.createWebhookMessage(webhookID, webhookToken, messageCreate, wait, threadID, CreateWebhookMessageSlack, opts)
}

func (s *webhookImpl) CreateWebhookMessageGitHub(webhookID snowflake.ID, webhookToken string, messageCreate discord.Payload, wait bool, threadID snowflake.ID, opts ...RequestOpt) (*discord.Message, error) {
	return s.createWebhookMessage(webhookID, webhookToken, messageCreate, wait, threadID, CreateWebhookMessageGitHub, opts)
}

func (s *webhookImpl) UpdateWebhookMessage(webhookID snowflake.ID, webhookToken string, messageID snowflake.ID, messageUpdate discord.WebhookMessageUpdate, threadID snowflake.ID, opts ...RequestOpt) (message *discord.Message, err error) {
	params := discord.QueryValues{}
	if threadID != 0 {
		params["thread_id"] = threadID
	}
	body, err := messageUpdate.ToBody()
	if err != nil {
		return
	}

	err = s.client.Do(UpdateWebhookMessage.Compile(params, webhookID, webhookToken, messageID), body, &message, opts...)
	return
}

func (s *webhookImpl) DeleteWebhookMessage(webhookID snowflake.ID, webhookToken string, messageID snowflake.ID, threadID snowflake.ID, opts ...RequestOpt) (err error) {
	params := discord.QueryValues{}
	if threadID != 0 {
		params["thread_id"] = threadID
	}
	err = s.client.Do(DeleteWebhookMessage.Compile(params, webhookID, webhookToken, messageID), nil, nil, opts...)
	return
}
