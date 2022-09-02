package discord

// InteractionResponseType indicates the type of slash command response, whether it's responding immediately or deferring to edit your response later
type InteractionResponseType int

// Constants for the InteractionResponseType(s)
const (
	InteractionResponseTypePong InteractionResponseType = iota + 1
	_
	_
	InteractionResponseTypeCreateMessage
	InteractionResponseTypeDeferredCreateMessage
	InteractionResponseTypeDeferredUpdateMessage
	InteractionResponseTypeUpdateMessage
	InteractionResponseTypeApplicationCommandAutocompleteResult
	InteractionResponseTypeModal
)

// InteractionResponse is how you answer interactions. If an answer is not sent within 3 seconds of receiving it, the interaction is failed, and you will be unable to respond to it.
type InteractionResponse struct {
	Type InteractionResponseType `json:"type"`
	Data InteractionResponseData `json:"data,omitempty"`
}

// ToBody returns the InteractionResponse ready for body
func (r InteractionResponse) ToBody() (any, error) {
	if v, ok := r.Data.(InteractionResponseCreator); ok {
		return v.ToResponseBody(r)
	}
	return r, nil
}

type InteractionResponseData interface {
	interactionCallbackData()
}

type InteractionResponseCreator interface {
	ToResponseBody(response InteractionResponse) (any, error)
}

type AutocompleteResult struct {
	Choices []AutocompleteChoice `json:"choices"`
}

func (AutocompleteResult) interactionCallbackData() {}

type AutocompleteChoice interface {
	autoCompleteChoice()
}

type AutocompleteChoiceString struct {
	Name              string            `json:"name"`
	NameLocalizations map[Locale]string `json:"name_localizations,omitempty"`
	Value             string            `json:"value"`
}

func (AutocompleteChoiceString) autoCompleteChoice() {}

type AutocompleteChoiceInt struct {
	Name              string            `json:"name"`
	NameLocalizations map[Locale]string `json:"name_localizations,omitempty"`
	Value             int               `json:"value"`
}

func (AutocompleteChoiceInt) autoCompleteChoice() {}

type AutocompleteChoiceFloat struct {
	Name              string            `json:"name"`
	NameLocalizations map[Locale]string `json:"name_localizations,omitempty"`
	Value             float64           `json:"value"`
}

func (AutocompleteChoiceFloat) autoCompleteChoice() {}
