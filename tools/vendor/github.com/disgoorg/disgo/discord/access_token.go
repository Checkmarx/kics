package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
)

// AccessTokenResponse is the response from the OAuth2 exchange endpoint.
// See https://discord.com/developers/docs/topics/oauth2#authorization-code-grant for more information.
type AccessTokenResponse struct {
	AccessToken  string        `json:"access_token"`
	TokenType    TokenType     `json:"token_type"`
	ExpiresIn    time.Duration `json:"expires_in"`
	RefreshToken string        `json:"refresh_token"`
	Scope        []OAuth2Scope `json:"scope"`

	// Webhook is only present if scopes include the OAuth2ScopeWebhookIncoming
	Webhook *IncomingWebhook `json:"webhook"`
}

// UnmarshalJSON implements json.Unmarshaler.
func (e *AccessTokenResponse) UnmarshalJSON(data []byte) error {
	type accessTokenResponse AccessTokenResponse
	var v struct {
		ExpiresIn int    `json:"expires_in"`
		Scope     string `json:"scope"`
		accessTokenResponse
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}

	*e = AccessTokenResponse(v.accessTokenResponse)
	e.ExpiresIn = time.Duration(v.ExpiresIn) * time.Second
	e.Scope = SplitScopes(v.Scope)
	return nil
}

func (e AccessTokenResponse) MarshalJSON() ([]byte, error) {
	type accessTokenResponse AccessTokenResponse
	return json.Marshal(struct {
		ExpiresIn int    `json:"expires_in"`
		Scope     string `json:"scope"`
		accessTokenResponse
	}{
		ExpiresIn:           int(e.ExpiresIn.Seconds()),
		Scope:               JoinScopes(e.Scope),
		accessTokenResponse: (accessTokenResponse)(e),
	})
}

// GrantType defines what type of request is being made.
type GrantType string

// Discord's supported GrantType(s).
const (
	GrantTypeAuthorizationCode GrantType = "authorization_code"
	GrantTypeRefreshToken      GrantType = "refresh_token"
)

// String returns the GrantType as a string.
func (t GrantType) String() string {
	return string(t)
}
