package discord

import (
	"fmt"

	"github.com/disgoorg/disgo/json"
)

var (
	_ Interaction = (*ComponentInteraction)(nil)
)

type ComponentInteraction struct {
	BaseInteraction
	Data    ComponentInteractionData `json:"data"`
	Message Message                  `json:"message"`
}

func (i *ComponentInteraction) UnmarshalJSON(data []byte) error {
	var baseInteraction baseInteractionImpl
	if err := json.Unmarshal(data, &baseInteraction); err != nil {
		return err
	}

	var interaction struct {
		Data    json.RawMessage `json:"data"`
		Message Message         `json:"message"`
	}
	if err := json.Unmarshal(data, &interaction); err != nil {
		return err
	}

	var cType struct {
		Type ComponentType `json:"component_type"`
	}

	if err := json.Unmarshal(interaction.Data, &cType); err != nil {
		return err
	}

	var (
		interactionData ComponentInteractionData
		err             error
	)
	switch cType.Type {
	case ComponentTypeButton:
		v := ButtonInteractionData{}
		err = json.Unmarshal(interaction.Data, &v)
		interactionData = v

	case ComponentTypeSelectMenu:
		v := SelectMenuInteractionData{}
		err = json.Unmarshal(interaction.Data, &v)
		interactionData = v

	default:
		return fmt.Errorf("unkown component interaction data with type %d received", cType.Type)
	}
	if err != nil {
		return err
	}

	i.BaseInteraction = baseInteraction

	i.Data = interactionData
	i.Message = interaction.Message
	return nil
}

func (ComponentInteraction) Type() InteractionType {
	return InteractionTypeComponent
}

func (i ComponentInteraction) ButtonInteractionData() ButtonInteractionData {
	return i.Data.(ButtonInteractionData)
}

func (i ComponentInteraction) SelectMenuInteractionData() SelectMenuInteractionData {
	return i.Data.(SelectMenuInteractionData)
}

func (ComponentInteraction) interaction() {}

type ComponentInteractionData interface {
	Type() ComponentType
	CustomID() string

	componentInteractionData()
}

type rawButtonInteractionData struct {
	Custom string `json:"custom_id"`
}

type ButtonInteractionData struct {
	customID string
}

func (d *ButtonInteractionData) UnmarshalJSON(data []byte) error {
	var v rawButtonInteractionData
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	d.customID = v.Custom
	return nil
}

func (d *ButtonInteractionData) MarshalJSON() ([]byte, error) {
	return json.Marshal(rawButtonInteractionData{
		Custom: d.customID,
	})
}

func (ButtonInteractionData) Type() ComponentType {
	return ComponentTypeButton
}

func (d ButtonInteractionData) CustomID() string {
	return d.customID
}

func (ButtonInteractionData) componentInteractionData() {}

var (
	_ ComponentInteractionData = (*SelectMenuInteractionData)(nil)
)

type rawSelectMenuInteractionData struct {
	Custom string   `json:"custom_id"`
	Values []string `json:"values"`
}

type SelectMenuInteractionData struct {
	customID string
	Values   []string
}

func (d *SelectMenuInteractionData) UnmarshalJSON(data []byte) error {
	var v rawSelectMenuInteractionData
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	d.customID = v.Custom
	d.Values = v.Values
	return nil
}

func (d SelectMenuInteractionData) MarshalJSON() ([]byte, error) {
	return json.Marshal(rawSelectMenuInteractionData{
		Custom: d.customID,
		Values: d.Values,
	})
}

func (SelectMenuInteractionData) Type() ComponentType {
	return ComponentTypeSelectMenu
}

func (d SelectMenuInteractionData) CustomID() string {
	return d.customID
}

func (SelectMenuInteractionData) componentInteractionData() {}
