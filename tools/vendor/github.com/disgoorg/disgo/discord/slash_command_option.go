package discord

import (
	"github.com/disgoorg/disgo/json"
)

type internalSlashCommandOption interface {
	name() string
	slashCommandOption()
}

type UnmarshalSlashCommandOption struct {
	internalSlashCommandOption
}

func (o *UnmarshalSlashCommandOption) UnmarshalJSON(data []byte) error {
	var oType struct {
		Type ApplicationCommandOptionType `json:"type"`
	}

	if err := json.Unmarshal(data, &oType); err != nil {
		return err
	}

	var (
		slashCommandOption internalSlashCommandOption
		err                error
	)

	switch oType.Type {
	case ApplicationCommandOptionTypeSubCommand:
		var v SlashCommandOptionSubCommand
		err = json.Unmarshal(data, &v)
		slashCommandOption = v

	case ApplicationCommandOptionTypeSubCommandGroup:
		var v SlashCommandOptionSubCommandGroup
		err = json.Unmarshal(data, &v)
		slashCommandOption = v

	default:
		var v SlashCommandOption
		err = json.Unmarshal(data, &v)
		slashCommandOption = v
	}
	if err != nil {
		return err
	}

	o.internalSlashCommandOption = slashCommandOption
	return nil
}

var _ internalSlashCommandOption = (*SlashCommandOptionSubCommand)(nil)

type SlashCommandOptionSubCommand struct {
	Name    string               `json:"name"`
	Options []SlashCommandOption `json:"options,omitempty"`
}

func (o SlashCommandOptionSubCommand) name() string {
	return o.Name
}
func (SlashCommandOptionSubCommand) slashCommandOption() {}

var _ internalSlashCommandOption = (*SlashCommandOptionSubCommandGroup)(nil)

type SlashCommandOptionSubCommandGroup struct {
	Name    string                         `json:"name"`
	Options []SlashCommandOptionSubCommand `json:"options,omitempty"`
}

func (o SlashCommandOptionSubCommandGroup) name() string {
	return o.Name
}
func (SlashCommandOptionSubCommandGroup) slashCommandOption() {}

var _ internalSlashCommandOption = (*SlashCommandOption)(nil)

type SlashCommandOption struct {
	Name  string                       `json:"name"`
	Type  ApplicationCommandOptionType `json:"type"`
	Value json.RawMessage              `json:"value"`
}

func (o SlashCommandOption) name() string {
	return o.Name
}
func (SlashCommandOption) slashCommandOption() {}
