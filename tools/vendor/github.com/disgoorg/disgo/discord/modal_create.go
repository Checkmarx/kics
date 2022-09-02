package discord

var _ InteractionResponseData = (*ModalCreate)(nil)

type ModalCreate struct {
	CustomID   string               `json:"custom_id"`
	Title      string               `json:"title"`
	Components []ContainerComponent `json:"components"`
}

func (ModalCreate) interactionCallbackData() {}

// NewModalCreateBuilder creates a new ModalCreateBuilder to be built later
func NewModalCreateBuilder() *ModalCreateBuilder {
	return &ModalCreateBuilder{}
}

type ModalCreateBuilder struct {
	ModalCreate
}

// SetCustomID sets the CustomID of the ModalCreate
func (b *ModalCreateBuilder) SetCustomID(customID string) *ModalCreateBuilder {
	b.CustomID = customID
	return b
}

// SetTitle sets the title of the ModalCreate
func (b *ModalCreateBuilder) SetTitle(title string) *ModalCreateBuilder {
	b.Title = title
	return b
}

// SetContainerComponents sets the discord.ContainerComponent(s) of the ModalCreate
func (b *ModalCreateBuilder) SetContainerComponents(containerComponents ...ContainerComponent) *ModalCreateBuilder {
	b.Components = containerComponents
	return b
}

// SetContainerComponent sets the provided discord.InteractiveComponent at the index of discord.InteractiveComponent(s)
func (b *ModalCreateBuilder) SetContainerComponent(i int, container ContainerComponent) *ModalCreateBuilder {
	if len(b.Components) > i {
		b.Components[i] = container
	}
	return b
}

// AddActionRow adds a new discord.ActionRowComponent with the provided discord.InteractiveComponent(s) to the ModalCreate
func (b *ModalCreateBuilder) AddActionRow(components ...InteractiveComponent) *ModalCreateBuilder {
	b.Components = append(b.Components, ActionRowComponent(components))
	return b
}

// AddContainerComponents adds the discord.ContainerComponent(s) to the ModalCreate
func (b *ModalCreateBuilder) AddContainerComponents(containers ...ContainerComponent) *ModalCreateBuilder {
	b.Components = append(b.Components, containers...)
	return b
}

// RemoveContainerComponent removes a discord.ActionRowComponent from the ModalCreate
func (b *ModalCreateBuilder) RemoveContainerComponent(i int) *ModalCreateBuilder {
	if len(b.Components) > i {
		b.Components = append(b.Components[:i], b.Components[i+1:]...)
	}
	return b
}

// ClearContainerComponents removes all the discord.ContainerComponent(s) of the ModalCreate
func (b *ModalCreateBuilder) ClearContainerComponents() *ModalCreateBuilder {
	b.Components = []ContainerComponent{}
	return b
}

// Build builds the ModalCreateBuilder to a ModalCreate struct
func (b *ModalCreateBuilder) Build() ModalCreate {
	return b.ModalCreate
}
