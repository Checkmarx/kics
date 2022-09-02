package internal

import (
	"net/http"

	"github.com/DisgoOrg/disgohook/api"

	"github.com/DisgoOrg/restclient"
)

func newRestClientImpl(httpClient *http.Client, webhook api.WebhookClient) api.RestClient {
	return &restClientImpl{
		RestClient:    restclient.NewRestClient(httpClient, webhook.Logger(), "DisgoHook", nil),
		webhookClient: webhook,
	}
}

type restClientImpl struct {
	restclient.RestClient
	webhookClient api.WebhookClient
}

func (r *restClientImpl) WebhookClient() api.WebhookClient {
	return r.webhookClient
}

func (r *restClientImpl) GetWebhook(webhookID api.Snowflake, webhookToken string) (webhook *api.Webhook, rErr restclient.RestError) {
	compiledRoute, err := restclient.GetWebhookWithToken.Compile(nil, webhookID, webhookToken)
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}
	rErr = r.Do(compiledRoute, nil, &webhook)
	return
}

func (r *restClientImpl) UpdateWebhook(webhookID api.Snowflake, webhookToken string, webhookUpdate api.WebhookUpdate) (webhook *api.Webhook, rErr restclient.RestError) {
	compiledRoute, err := restclient.UpdateWebhookWithToken.Compile(nil, webhookID, webhookToken)
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}
	rErr = r.Do(compiledRoute, webhookUpdate, &webhook)
	return
}

func (r *restClientImpl) DeleteWebhook(webhookID api.Snowflake, webhookToken string) (rErr restclient.RestError) {
	compiledRoute, err := restclient.DeleteWebhookWithToken.Compile(nil, webhookID, webhookToken)
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}
	rErr = r.Do(compiledRoute, nil, nil)
	return
}

func (r *restClientImpl) CreateWebhookMessage(webhookID api.Snowflake, webhookToken string, messageCreate api.WebhookMessageCreate, wait bool, threadID api.Snowflake) (message *api.WebhookMessage, rErr restclient.RestError) {
	params := restclient.QueryValues{}
	if wait {
		params["wait"] = true
	}
	if threadID != "" {
		params["thread_id"] = threadID
	}
	compiledRoute, err := restclient.CreateWebhookMessage.Compile(params, webhookID, webhookToken)
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}

	body, err := messageCreate.ToBody()
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}

	if wait {
		rErr = r.Do(compiledRoute, body, &message)
	} else {
		rErr = r.Do(compiledRoute, body, nil)
	}
	if message != nil {
		message = r.createMessage(message)
	}
	return
}

func (r *restClientImpl) UpdateWebhookMessage(webhookID api.Snowflake, webhookToken string, messageID api.Snowflake, messageUpdate api.WebhookMessageUpdate) (message *api.WebhookMessage, rErr restclient.RestError) {
	compiledRoute, err := restclient.UpdateWebhookMessage.Compile(nil, webhookID, webhookToken, messageID)
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}

	body, err := messageUpdate.ToBody()
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}

	rErr = r.Do(compiledRoute, body, &message)
	if message != nil {
		message = r.createMessage(message)
	}
	return
}

func (r *restClientImpl) DeleteWebhookMessage(webhookID api.Snowflake, webhookToken string, messageID api.Snowflake) (rErr restclient.RestError) {
	compiledRoute, err := restclient.DeleteWebhookMessage.Compile(nil, webhookID, webhookToken, messageID)
	if err != nil {
		rErr = restclient.NewError(nil, err)
		return
	}
	rErr = r.Do(compiledRoute, nil, nil)
	return
}

func (r *restClientImpl) createComponent(unmarshalComponent api.UnmarshalComponent) api.Component {
	switch unmarshalComponent.ComponentType {
	case api.ComponentTypeActionRow:
		components := make([]api.Component, len(unmarshalComponent.Components))
		for i, unmarshalC := range unmarshalComponent.Components {
			components[i] = r.createComponent(unmarshalC)
		}
		return &api.ActionRow{
			ComponentImpl: api.ComponentImpl{
				ComponentType: api.ComponentTypeActionRow,
			},
			Components: components,
		}

	case api.ComponentTypeButton:
		button := &api.Button{
			ComponentImpl: api.ComponentImpl{
				ComponentType: api.ComponentTypeButton,
			},
			Style:    unmarshalComponent.Style,
			Label:    unmarshalComponent.Label,
			CustomID: unmarshalComponent.CustomID,
			URL:      unmarshalComponent.URL,
			Disabled: unmarshalComponent.Disabled,
			Emoji:    unmarshalComponent.Emoji,
		}
		return button

	default:
		r.Logger().Errorf("unexpected component type %d received", unmarshalComponent.ComponentType)
		return nil
	}
}

func (r *restClientImpl) createMessage(message *api.WebhookMessage) *api.WebhookMessage {
	message.Webhook = r.webhookClient
	return message
}
