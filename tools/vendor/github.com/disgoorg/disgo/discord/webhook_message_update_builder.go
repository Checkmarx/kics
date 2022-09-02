package discord

import (
	"fmt"
	"io"

	"github.com/disgoorg/snowflake/v2"
)

// WebhookMessageUpdateBuilder helper to build MessageUpdate easier
type WebhookMessageUpdateBuilder struct {
	WebhookMessageUpdate
}

// NewWebhookMessageUpdateBuilder creates a new WebhookMessageUpdateBuilder to be built later
func NewWebhookMessageUpdateBuilder() *WebhookMessageUpdateBuilder {
	return &WebhookMessageUpdateBuilder{
		WebhookMessageUpdate: WebhookMessageUpdate{
			AllowedMentions: &DefaultAllowedMentions,
		},
	}
}

// SetContent sets content of the Message
func (b *WebhookMessageUpdateBuilder) SetContent(content string) *WebhookMessageUpdateBuilder {
	b.Content = &content
	return b
}

// SetContentf sets content of the Message
func (b *WebhookMessageUpdateBuilder) SetContentf(content string, a ...any) *WebhookMessageUpdateBuilder {
	return b.SetContent(fmt.Sprintf(content, a...))
}

// ClearContent removes content of the Message
func (b *WebhookMessageUpdateBuilder) ClearContent() *WebhookMessageUpdateBuilder {
	return b.SetContent("")
}

// SetEmbeds sets the Embed(s) of the Message
func (b *WebhookMessageUpdateBuilder) SetEmbeds(embeds ...Embed) *WebhookMessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	*b.Embeds = embeds
	return b
}

// SetEmbed sets the provided Embed at the index of the Message
func (b *WebhookMessageUpdateBuilder) SetEmbed(i int, embed Embed) *WebhookMessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	if len(*b.Embeds) > i {
		(*b.Embeds)[i] = embed
	}
	return b
}

// AddEmbeds adds multiple embeds to the Message
func (b *WebhookMessageUpdateBuilder) AddEmbeds(embeds ...Embed) *WebhookMessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	*b.Embeds = append(*b.Embeds, embeds...)
	return b
}

// ClearEmbeds removes all the embeds from the Message
func (b *WebhookMessageUpdateBuilder) ClearEmbeds() *WebhookMessageUpdateBuilder {
	b.Embeds = &[]Embed{}
	return b
}

// RemoveEmbed removes an embed from the Message
func (b *WebhookMessageUpdateBuilder) RemoveEmbed(i int) *WebhookMessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	if len(*b.Embeds) > i {
		*b.Embeds = append((*b.Embeds)[:i], (*b.Embeds)[i+1:]...)
	}
	return b
}

// SetContainerComponents sets the discord.ContainerComponent(s) of the Message
func (b *WebhookMessageUpdateBuilder) SetContainerComponents(containerComponents ...ContainerComponent) *WebhookMessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	*b.Components = containerComponents
	return b
}

// SetContainerComponent sets the provided discord.InteractiveComponent at the index of discord.InteractiveComponent(s)
func (b *WebhookMessageUpdateBuilder) SetContainerComponent(i int, container ContainerComponent) *WebhookMessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	if len(*b.Components) > i {
		(*b.Components)[i] = container
	}
	return b
}

// AddActionRow adds a new discord.ActionRowComponent with the provided discord.InteractiveComponent(s) to the Message
func (b *WebhookMessageUpdateBuilder) AddActionRow(components ...InteractiveComponent) *WebhookMessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	*b.Components = append(*b.Components, ActionRowComponent(components))
	return b
}

// AddContainerComponents adds the discord.ContainerComponent(s) to the Message
func (b *WebhookMessageUpdateBuilder) AddContainerComponents(containers ...ContainerComponent) *WebhookMessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	*b.Components = append(*b.Components, containers...)
	return b
}

// RemoveContainerComponent removes a discord.ContainerComponent from the Message
func (b *WebhookMessageUpdateBuilder) RemoveContainerComponent(i int) *WebhookMessageUpdateBuilder {
	if b.Components == nil {
		return b
	}
	if len(*b.Components) > i {
		*b.Components = append((*b.Components)[:i], (*b.Components)[i+1:]...)
	}
	return b
}

// ClearContainerComponents removes all the discord.ContainerComponent(s) of the Message
func (b *WebhookMessageUpdateBuilder) ClearContainerComponents() *WebhookMessageUpdateBuilder {
	b.Components = &[]ContainerComponent{}
	return b
}

// SetFiles sets the new discord.File(s) for this discord.MessageUpdate
func (b *WebhookMessageUpdateBuilder) SetFiles(files ...*File) *WebhookMessageUpdateBuilder {
	b.Files = files
	return b
}

// SetFile sets the new discord.File at the index for this discord.MessageUpdate
func (b *WebhookMessageUpdateBuilder) SetFile(i int, file *File) *WebhookMessageUpdateBuilder {
	if len(b.Files) > i {
		b.Files[i] = file
	}
	return b
}

// AddFiles adds the new discord.File(s) to the discord.MessageUpdate
func (b *WebhookMessageUpdateBuilder) AddFiles(files ...*File) *WebhookMessageUpdateBuilder {
	b.Files = append(b.Files, files...)
	return b
}

// AddFile adds a new discord.File to the discord.MessageUpdate
func (b *WebhookMessageUpdateBuilder) AddFile(name string, description string, reader io.Reader, flags ...FileFlags) *WebhookMessageUpdateBuilder {
	b.Files = append(b.Files, NewFile(name, description, reader, flags...))
	return b
}

// ClearFiles removes all new discord.File(s) of this discord.MessageUpdate
func (b *WebhookMessageUpdateBuilder) ClearFiles() *WebhookMessageUpdateBuilder {
	b.Files = []*File{}
	return b
}

// RemoveFile removes the new discord.File at this index
func (b *WebhookMessageUpdateBuilder) RemoveFile(i int) *WebhookMessageUpdateBuilder {
	if len(b.Files) > i {
		b.Files = append(b.Files[:i], b.Files[i+1:]...)
	}
	return b
}

// RetainAttachments removes all Attachment(s) from this Message except the ones provided
func (b *WebhookMessageUpdateBuilder) RetainAttachments(attachments ...Attachment) *WebhookMessageUpdateBuilder {
	if b.Attachments == nil {
		b.Attachments = new([]AttachmentUpdate)
	}
	for _, attachment := range attachments {
		*b.Attachments = append(*b.Attachments, AttachmentKeep{ID: attachment.ID})
	}
	return b
}

// RetainAttachmentsByID removes all Attachment(s) from this Message except the ones provided
func (b *WebhookMessageUpdateBuilder) RetainAttachmentsByID(attachmentIDs ...snowflake.ID) *WebhookMessageUpdateBuilder {
	if b.Attachments == nil {
		b.Attachments = new([]AttachmentUpdate)
	}
	for _, attachmentID := range attachmentIDs {
		*b.Attachments = append(*b.Attachments, AttachmentKeep{ID: attachmentID})
	}
	return b
}

// SetAllowedMentions sets the AllowedMentions of the Message
func (b *WebhookMessageUpdateBuilder) SetAllowedMentions(allowedMentions *AllowedMentions) *WebhookMessageUpdateBuilder {
	b.AllowedMentions = allowedMentions
	return b
}

// ClearAllowedMentions clears the allowed mentions of the Message
func (b *WebhookMessageUpdateBuilder) ClearAllowedMentions() *WebhookMessageUpdateBuilder {
	return b.SetAllowedMentions(nil)
}

// Build builds the WebhookMessageUpdateBuilder to a MessageUpdate struct
func (b *WebhookMessageUpdateBuilder) Build() WebhookMessageUpdate {
	return b.WebhookMessageUpdate
}
