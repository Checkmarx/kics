package discord

import (
	"fmt"
	"net/url"
	"strings"

	"github.com/disgoorg/snowflake/v2"
)

// QueryValues holds key value pairs of query values
type QueryValues map[string]any

// Encode encodes the QueryValues into a string to append to the url
func (q QueryValues) Encode() string {
	values := url.Values{}
	for k, v := range q {
		values.Set(k, fmt.Sprint(v))
	}
	return values.Encode()
}

func urlPrint(url string, params ...any) string {
	for _, param := range params {
		start := strings.Index(url, "{")
		end := strings.Index(url, "}")
		if start == -1 || end == -1 {
			break
		}
		url = url[:start] + fmt.Sprint(param) + url[end+1:]
	}
	return url
}

// InviteURL formats the invite code as an url
func InviteURL(code string) string {
	return urlPrint("https://discord.gg/{code}", code)
}

// WebhookURL returns the url over which the webhook can be called
func WebhookURL(webhookID snowflake.ID, webhookToken string) string {
	return urlPrint("https://discord.com/api/webhooks/{webhook.id}/{webhook.token}", webhookID, webhookToken)
}

// AuthorizeURL returns the OAuth2 authorize url with the given query params
func AuthorizeURL(values QueryValues) string {
	query := values.Encode()
	if query != "" {
		query = "?" + query
	}
	return "https://discord.com/api/oauth2/authorize" + query
}
