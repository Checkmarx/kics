package discord

import (
	"github.com/disgoorg/disgo/json"
)

type internalAutocompleteOption interface {
	name() string
	autocompleteOption()
}

type UnmarshalAutocompleteOption struct {
	internalAutocompleteOption
}

func (o *UnmarshalAutocompleteOption) UnmarshalJSON(data []byte) error {
	var oType struct {
		Type ApplicationCommandOptionType `json:"type"`
	}

	if err := json.Unmarshal(data, &oType); err != nil {
		return err
	}

	var (
		autocompleteOption internalAutocompleteOption
		err                error
	)

	switch oType.Type {
	case ApplicationCommandOptionTypeSubCommand:
		var v AutocompleteOptionSubCommand
		err = json.Unmarshal(data, &v)
		autocompleteOption = v

	case ApplicationCommandOptionTypeSubCommandGroup:
		var v AutocompleteOptionSubCommandGroup
		err = json.Unmarshal(data, &v)
		autocompleteOption = v

	default:
		var v AutocompleteOption
		err = json.Unmarshal(data, &v)
		autocompleteOption = v
	}

	if err != nil {
		return err
	}

	o.internalAutocompleteOption = autocompleteOption
	return nil
}

var _ internalAutocompleteOption = (*AutocompleteOptionSubCommand)(nil)

type AutocompleteOptionSubCommand struct {
	Name        string               `json:"name"`
	Description string               `json:"description"`
	Options     []AutocompleteOption `json:"options,omitempty"`
}

func (o AutocompleteOptionSubCommand) name() string {
	return o.Name
}
func (AutocompleteOptionSubCommand) autocompleteOption() {}

var _ internalAutocompleteOption = (*AutocompleteOptionSubCommandGroup)(nil)

type AutocompleteOptionSubCommandGroup struct {
	Name        string                         `json:"name"`
	Description string                         `json:"description"`
	Options     []AutocompleteOptionSubCommand `json:"options,omitempty"`
}

func (o AutocompleteOptionSubCommandGroup) name() string {
	return o.Name
}
func (AutocompleteOptionSubCommandGroup) autocompleteOption() {}

var _ internalAutocompleteOption = (*AutocompleteOption)(nil)

type AutocompleteOption struct {
	Name    string                       `json:"name"`
	Type    ApplicationCommandOptionType `json:"type"`
	Value   json.RawMessage              `json:"value"`
	Focused bool                         `json:"focused"`
}

func (o AutocompleteOption) name() string {
	return o.Name
}
func (AutocompleteOption) autocompleteOption() {}
