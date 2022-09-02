package api

import (
	"github.com/DisgoOrg/restclient"
)

// RestClient is a manager for all of disgohook's HTTP requests
type RestClient interface {
	restclient.RestClient
	WebhookClient() WebhookClient

	GetWebhook(webhookID Snowflake, webhookToken string) (*Webhook, restclient.RestError)
	UpdateWebhook(webhookID Snowflake, webhookToken string, webhookUpdate WebhookUpdate) (*Webhook, restclient.RestError)
	DeleteWebhook(webhookID Snowflake, webhookToken string) restclient.RestError

	CreateWebhookMessage(webhookID Snowflake, webhookToken string, messageCreate WebhookMessageCreate, wait bool, threadID Snowflake) (*WebhookMessage, restclient.RestError)
	UpdateWebhookMessage(webhookID Snowflake, webhookToken string, messageID Snowflake, messageUpdate WebhookMessageUpdate) (*WebhookMessage, restclient.RestError)
	DeleteWebhookMessage(webhookID Snowflake, webhookToken string, messageID Snowflake) restclient.RestError
}
