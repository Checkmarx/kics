package disgohook

import (
	"net/http"
	"strings"

	"github.com/DisgoOrg/disgohook/api"
	"github.com/DisgoOrg/disgohook/internal"
	"github.com/DisgoOrg/log"
)

// NewWebhookClientByToken returns a new api.WebhookClient with the given http.Client, log.Logger & webhookID/webhookToken
func NewWebhookClientByToken(httpClient *http.Client, logger log.Logger, webhookToken string) (api.WebhookClient, error) {
	webhookTokenSplit := strings.SplitN(webhookToken, "/", 2)
	if len(webhookTokenSplit) != 2 {
		return nil, api.ErrMalformedWebhookToken
	}
	return NewWebhookClientByIDToken(httpClient, logger, api.Snowflake(webhookTokenSplit[0]), webhookTokenSplit[1])
}

// NewWebhookClientByIDToken returns a new api.WebhookClient with the given http.Client, log.Logger, webhookID & webhookToken
func NewWebhookClientByIDToken(httpClient *http.Client, logger log.Logger, webhookID api.Snowflake, webhookToken string) (api.WebhookClient, error) {
	return internal.NewWebhookClientImpl(httpClient, logger, webhookID, webhookToken), nil
}
