package discord

import (
	"fmt"
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

// IntegrationType the type of Integration
type IntegrationType string

// All IntegrationType(s)
const (
	IntegrationTypeTwitch  IntegrationType = "twitch"
	IntegrationTypeYouTube IntegrationType = "youtube"
	IntegrationTypeBot     IntegrationType = "discord"
)

// IntegrationAccount (https://discord.com/developers/docs/resources/guild#integration-account-object)
type IntegrationAccount struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

// IntegrationApplication (https://discord.com/developers/docs/resources/guild#integration-application-object)
type IntegrationApplication struct {
	ID          snowflake.ID `json:"id"`
	Name        string       `json:"name"`
	Icon        string       `json:"icon"`
	Description string       `json:"description"`
	Summary     string       `json:"summary"`
	Client      User         `json:"bot"`
}

// Integration (https://discord.com/developers/docs/resources/guild#integration-object)
type Integration interface {
	json.Marshaler
	Type() IntegrationType
	ID() snowflake.ID
	CreatedAt() time.Time
}

type UnmarshalIntegration struct {
	Integration
}

func (i *UnmarshalIntegration) UnmarshalJSON(data []byte) error {
	var cType struct {
		Type IntegrationType `json:"type"`
	}

	if err := json.Unmarshal(data, &cType); err != nil {
		return err
	}

	var (
		integration Integration
		err         error
	)

	switch cType.Type {
	case IntegrationTypeTwitch:
		var v TwitchIntegration
		err = json.Unmarshal(data, &v)
		integration = v

	case IntegrationTypeYouTube:
		var v YouTubeIntegration
		err = json.Unmarshal(data, &v)
		integration = v

	case IntegrationTypeBot:
		var v BotIntegration
		err = json.Unmarshal(data, &v)
		integration = v

	default:
		err = fmt.Errorf("unkown integration with type %s received", cType.Type)
	}

	if err != nil {
		return err
	}

	i.Integration = integration
	return nil
}

type TwitchIntegration struct {
	IntegrationID     snowflake.ID       `json:"id"`
	Name              string             `json:"name"`
	Enabled           bool               `json:"enabled"`
	Syncing           bool               `json:"syncing"`
	RoleID            snowflake.ID       `json:"role_id"`
	EnableEmoticons   bool               `json:"enable_emoticons"`
	ExpireBehavior    int                `json:"expire_behavior"`
	ExpireGracePeriod int                `json:"expire_grace_period"`
	User              User               `json:"user"`
	Account           IntegrationAccount `json:"account"`
	SyncedAt          string             `json:"synced_at"`
	SubscriberCount   int                `json:"subscriber_account"`
	Revoked           bool               `json:"revoked"`
}

func (i TwitchIntegration) MarshalJSON() ([]byte, error) {
	type twitchIntegration TwitchIntegration
	return json.Marshal(struct {
		Type IntegrationType `json:"type"`
		twitchIntegration
	}{
		Type:              i.Type(),
		twitchIntegration: twitchIntegration(i),
	})
}

func (TwitchIntegration) Type() IntegrationType {
	return IntegrationTypeTwitch
}

func (i TwitchIntegration) ID() snowflake.ID {
	return i.IntegrationID
}

func (i TwitchIntegration) CreatedAt() time.Time {
	return i.IntegrationID.Time()
}

type YouTubeIntegration struct {
	IntegrationID     snowflake.ID       `json:"id"`
	Name              string             `json:"name"`
	Enabled           bool               `json:"enabled"`
	Syncing           bool               `json:"syncing"`
	RoleID            snowflake.ID       `json:"role_id"`
	ExpireBehavior    int                `json:"expire_behavior"`
	ExpireGracePeriod int                `json:"expire_grace_period"`
	User              User               `json:"user"`
	Account           IntegrationAccount `json:"account"`
	SyncedAt          string             `json:"synced_at"`
	SubscriberCount   int                `json:"subscriber_account"`
	Revoked           bool               `json:"revoked"`
}

func (i YouTubeIntegration) MarshalJSON() ([]byte, error) {
	type youTubeIntegration YouTubeIntegration
	return json.Marshal(struct {
		Type IntegrationType `json:"type"`
		youTubeIntegration
	}{
		Type:               i.Type(),
		youTubeIntegration: youTubeIntegration(i),
	})
}

func (YouTubeIntegration) Type() IntegrationType {
	return IntegrationTypeTwitch
}

func (i YouTubeIntegration) ID() snowflake.ID {
	return i.IntegrationID
}

func (i YouTubeIntegration) CreatedAt() time.Time {
	return i.IntegrationID.Time()
}

type BotIntegration struct {
	IntegrationID snowflake.ID           `json:"id"`
	Name          string                 `json:"name"`
	Enabled       bool                   `json:"enabled"`
	Account       IntegrationAccount     `json:"account"`
	Application   IntegrationApplication `json:"application"`
}

func (i BotIntegration) MarshalJSON() ([]byte, error) {
	type botIntegration BotIntegration
	return json.Marshal(struct {
		Type IntegrationType `json:"type"`
		botIntegration
	}{
		Type:           i.Type(),
		botIntegration: botIntegration(i),
	})
}

func (BotIntegration) Type() IntegrationType {
	return IntegrationTypeBot
}

func (i BotIntegration) ID() snowflake.ID {
	return i.IntegrationID
}

func (i BotIntegration) CreatedAt() time.Time {
	return i.IntegrationID.Time()
}
