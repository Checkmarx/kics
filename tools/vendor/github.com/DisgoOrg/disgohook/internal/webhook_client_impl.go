package internal

import (
	"net/http"

	"github.com/DisgoOrg/log"
	"github.com/DisgoOrg/restclient"

	"github.com/DisgoOrg/disgohook/api"
)

var _ api.WebhookClient = (*webhookClientImpl)(nil)

// NewWebhookClientImpl returns a new api.WebhookClient
func NewWebhookClientImpl(client *http.Client, logger log.Logger, id api.Snowflake, token string) api.WebhookClient {
	if logger == nil {
		logger = log.Default()
	}
	webhook := &webhookClientImpl{
		logger:                 logger,
		defaultAllowedMentions: &api.DefaultAllowedMentions,
		id:                     id,
		token:                  token,
	}
	webhook.restClient = newRestClientImpl(client, webhook)
	return webhook
}

type webhookClientImpl struct {
	restClient             api.RestClient
	logger                 log.Logger
	defaultAllowedMentions *api.AllowedMentions
	id                     api.Snowflake
	token                  string
}

func (h *webhookClientImpl) RestClient() api.RestClient {
	return h.restClient
}
func (h *webhookClientImpl) Logger() log.Logger {
	return h.logger
}
func (h *webhookClientImpl) DefaultAllowedMentions() *api.AllowedMentions {
	return h.defaultAllowedMentions
}
func (h *webhookClientImpl) SetDefaultAllowedMentions(allowedMentions *api.AllowedMentions) {
	h.defaultAllowedMentions = allowedMentions
}

func (h *webhookClientImpl) GetWebhook() (*api.Webhook, restclient.RestError) {
	return h.RestClient().GetWebhook(h.id, h.token)
}

func (h *webhookClientImpl) EditWebhook(webhookUpdate api.WebhookUpdate) (*api.Webhook, restclient.RestError) {
	return h.RestClient().UpdateWebhook(h.id, h.token, webhookUpdate)
}

func (h *webhookClientImpl) DeleteWebhook() restclient.RestError {
	return h.RestClient().DeleteWebhook(h.id, h.token)
}

func (h *webhookClientImpl) SendMessage(message api.WebhookMessageCreate) (*api.WebhookMessage, restclient.RestError) {
	return h.RestClient().CreateWebhookMessage(h.id, h.token, message, true, "")
}

func (h *webhookClientImpl) SendContent(content string) (*api.WebhookMessage, restclient.RestError) {
	return h.SendMessage(api.NewWebhookMessageCreateBuilder().SetContent(content).Build())
}

func (h *webhookClientImpl) SendEmbeds(embeds ...api.Embed) (*api.WebhookMessage, restclient.RestError) {
	return h.SendMessage(api.NewWebhookMessageCreateBuilder().SetEmbeds(embeds...).Build())
}

func (h *webhookClientImpl) EditMessage(messageID api.Snowflake, message api.WebhookMessageUpdate) (*api.WebhookMessage, restclient.RestError) {
	return h.RestClient().UpdateWebhookMessage(h.id, h.token, messageID, message)
}

func (h *webhookClientImpl) EditContent(messageID api.Snowflake, content string) (*api.WebhookMessage, restclient.RestError) {
	return h.EditMessage(messageID, api.NewWebhookMessageUpdateBuilder().SetContent(content).Build())
}

func (h *webhookClientImpl) EditEmbeds(messageID api.Snowflake, embeds ...api.Embed) (*api.WebhookMessage, restclient.RestError) {
	return h.EditMessage(messageID, api.NewWebhookMessageUpdateBuilder().SetEmbeds(embeds...).Build())
}

func (h *webhookClientImpl) DeleteMessage(messageID api.Snowflake) restclient.RestError {
	return h.RestClient().DeleteWebhookMessage(h.id, h.token, messageID)
}

func (h *webhookClientImpl) Token() string {
	return h.token
}
func (h *webhookClientImpl) ID() api.Snowflake {
	return h.id
}
func (h *webhookClientImpl) URL() string {
	compiledRoute, _ := restclient.GetWebhook.Compile(nil, h.id, h.token)
	return compiledRoute.Route()
}
