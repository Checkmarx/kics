package api

import (
	"errors"
	"github.com/DisgoOrg/restclient"
	"regexp"

	"github.com/DisgoOrg/log"
)

// WebhookURLPattern is the URL pattern for Webhook(s)
var WebhookURLPattern = regexp.MustCompile("(?:https?://)?(?:\\w+\\.)?discord(?:app)?\\.com/api(?:/v\\d+)?/webhooks/(\\d+)/([\\w-]+)(?:/(?:\\w+)?)?")

// ErrMalformedWebhookToken is returned for invalid webhook tokens
var ErrMalformedWebhookToken = errors.New("malformed webhook token <id>/<token>")

// WebhookClient lets you edit/send WebhookMessage(s) or update/delete the Webhook
type WebhookClient interface {
	RestClient() RestClient
	Logger() log.Logger
	DefaultAllowedMentions() *AllowedMentions
	SetDefaultAllowedMentions(allowedMentions *AllowedMentions)

	GetWebhook() (*Webhook, restclient.RestError)
	EditWebhook(webhookUpdate WebhookUpdate) (*Webhook, restclient.RestError)
	DeleteWebhook() restclient.RestError

	SendMessage(message WebhookMessageCreate) (*WebhookMessage, restclient.RestError)
	SendContent(content string) (*WebhookMessage, restclient.RestError)
	SendEmbeds(embeds ...Embed) (*WebhookMessage, restclient.RestError)

	EditMessage(messageID Snowflake, message WebhookMessageUpdate) (*WebhookMessage, restclient.RestError)
	EditContent(messageID Snowflake, content string) (*WebhookMessage, restclient.RestError)
	EditEmbeds(messageID Snowflake, embeds ...Embed) (*WebhookMessage, restclient.RestError)

	DeleteMessage(id Snowflake) restclient.RestError

	Token() string
	ID() Snowflake
	URL() string
}
