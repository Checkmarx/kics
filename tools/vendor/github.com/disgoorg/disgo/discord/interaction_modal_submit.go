package discord

import "github.com/disgoorg/disgo/json"

var (
	_ Interaction = (*ModalSubmitInteraction)(nil)
)

type ModalSubmitInteraction struct {
	BaseInteraction
	Data ModalSubmitInteractionData `json:"data"`
}

func (i *ModalSubmitInteraction) UnmarshalJSON(data []byte) error {
	var baseInteraction baseInteractionImpl
	if err := json.Unmarshal(data, &baseInteraction); err != nil {
		return err
	}

	var interaction struct {
		Data ModalSubmitInteractionData `json:"data"`
	}
	if err := json.Unmarshal(data, &interaction); err != nil {
		return err
	}

	i.BaseInteraction = baseInteraction
	i.Data = interaction.Data
	return nil
}

func (ModalSubmitInteraction) Type() InteractionType {
	return InteractionTypeModalSubmit
}

func (ModalSubmitInteraction) interaction() {}

type ModalSubmitInteractionData struct {
	CustomID   string                          `json:"custom_id"`
	Components map[string]InteractiveComponent `json:"components"`
}

func (d *ModalSubmitInteractionData) UnmarshalJSON(data []byte) error {
	type modalSubmitInteractionData ModalSubmitInteractionData
	var iData struct {
		Components []UnmarshalComponent `json:"components"`
		modalSubmitInteractionData
	}

	if err := json.Unmarshal(data, &iData); err != nil {
		return err
	}

	*d = ModalSubmitInteractionData(iData.modalSubmitInteractionData)

	if len(iData.Components) > 0 {
		d.Components = make(map[string]InteractiveComponent, len(iData.Components))
		for _, containerComponent := range iData.Components {
			for _, component := range containerComponent.Component.(ContainerComponent).Components() {
				d.Components[component.ID()] = component
			}
		}
	}
	return nil
}

func (d ModalSubmitInteractionData) Component(customID string) (InteractiveComponent, bool) {
	component, ok := d.Components[customID]
	return component, ok
}

func (d ModalSubmitInteractionData) TextInputComponent(customID string) (TextInputComponent, bool) {
	if component, ok := d.Component(customID); ok {
		textInputComponent, ok := component.(TextInputComponent)
		return textInputComponent, ok
	}
	return TextInputComponent{}, false
}

func (d ModalSubmitInteractionData) OptText(customID string) (string, bool) {
	if textInputComponent, ok := d.TextInputComponent(customID); ok {
		return textInputComponent.Value, true
	}
	return "", false
}

func (d ModalSubmitInteractionData) Text(customID string) string {
	if text, ok := d.OptText(customID); ok {
		return text
	}
	return ""
}
