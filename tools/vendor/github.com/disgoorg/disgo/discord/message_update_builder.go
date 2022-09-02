package discord

import (
	"fmt"
	"io"

	"github.com/disgoorg/snowflake/v2"
)

// MessageUpdateBuilder helper to build MessageUpdate easier
type MessageUpdateBuilder struct {
	MessageUpdate
}

// NewMessageUpdateBuilder creates a new MessageUpdateBuilder to be built later
func NewMessageUpdateBuilder() *MessageUpdateBuilder {
	return &MessageUpdateBuilder{
		MessageUpdate: MessageUpdate{
			AllowedMentions: &DefaultAllowedMentions,
		},
	}
}

// SetContent sets content of the Message
func (b *MessageUpdateBuilder) SetContent(content string) *MessageUpdateBuilder {
	b.Content = &content
	return b
}

// SetContentf sets content of the Message
func (b *MessageUpdateBuilder) SetContentf(content string, a ...any) *MessageUpdateBuilder {
	return b.SetContent(fmt.Sprintf(content, a...))
}

// ClearContent removes content of the Message
func (b *MessageUpdateBuilder) ClearContent() *MessageUpdateBuilder {
	return b.SetContent("")
}

// SetEmbeds sets the discord.Embed(s) of the Message
func (b *MessageUpdateBuilder) SetEmbeds(embeds ...Embed) *MessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	*b.Embeds = embeds
	return b
}

// SetEmbed sets the provided discord.Embed at the index of the Message
func (b *MessageUpdateBuilder) SetEmbed(i int, embed Embed) *MessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	if len(*b.Embeds) > i {
		(*b.Embeds)[i] = embed
	}
	return b
}

// AddEmbeds adds multiple embeds to the Message
func (b *MessageUpdateBuilder) AddEmbeds(embeds ...Embed) *MessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	*b.Embeds = append(*b.Embeds, embeds...)
	return b
}

// ClearEmbeds removes all the embeds from the Message
func (b *MessageUpdateBuilder) ClearEmbeds() *MessageUpdateBuilder {
	b.Embeds = &[]Embed{}
	return b
}

// RemoveEmbed removes an embed from the Message
func (b *MessageUpdateBuilder) RemoveEmbed(i int) *MessageUpdateBuilder {
	if b.Embeds == nil {
		b.Embeds = new([]Embed)
	}
	if len(*b.Embeds) > i {
		*b.Embeds = append((*b.Embeds)[:i], (*b.Embeds)[i+1:]...)
	}
	return b
}

// SetContainerComponents sets the discord.ContainerComponent(s) of the Message
func (b *MessageUpdateBuilder) SetContainerComponents(containerComponents ...ContainerComponent) *MessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	*b.Components = containerComponents
	return b
}

// SetContainerComponent sets the provided discord.InteractiveComponent at the index of discord.InteractiveComponent(s)
func (b *MessageUpdateBuilder) SetContainerComponent(i int, container ContainerComponent) *MessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	if len(*b.Components) > i {
		(*b.Components)[i] = container
	}
	return b
}

// AddActionRow adds a new discord.ActionRowComponent with the provided discord.InteractiveComponent(s) to the Message
func (b *MessageUpdateBuilder) AddActionRow(components ...InteractiveComponent) *MessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	*b.Components = append(*b.Components, ActionRowComponent(components))
	return b
}

// AddContainerComponents adds the discord.ContainerComponent(s) to the Message
func (b *MessageUpdateBuilder) AddContainerComponents(containers ...ContainerComponent) *MessageUpdateBuilder {
	if b.Components == nil {
		b.Components = new([]ContainerComponent)
	}
	*b.Components = append(*b.Components, containers...)
	return b
}

// RemoveContainerComponent removes a discord.ContainerComponent from the Message
func (b *MessageUpdateBuilder) RemoveContainerComponent(i int) *MessageUpdateBuilder {
	if b.Components == nil {
		return b
	}
	if len(*b.Components) > i {
		*b.Components = append((*b.Components)[:i], (*b.Components)[i+1:]...)
	}
	return b
}

// ClearContainerComponents removes all the discord.ContainerComponent(s) of the Message
func (b *MessageUpdateBuilder) ClearContainerComponents() *MessageUpdateBuilder {
	b.Components = &[]ContainerComponent{}
	return b
}

// SetFiles sets the new discord.File(s) for this discord.MessageUpdate
func (b *MessageUpdateBuilder) SetFiles(files ...*File) *MessageUpdateBuilder {
	b.Files = files
	return b
}

// SetFile sets the new discord.File at the index for this discord.MessageUpdate
func (b *MessageUpdateBuilder) SetFile(i int, file *File) *MessageUpdateBuilder {
	if len(b.Files) > i {
		b.Files[i] = file
	}
	return b
}

// AddFiles adds the new discord.File(s) to the discord.MessageUpdate
func (b *MessageUpdateBuilder) AddFiles(files ...*File) *MessageUpdateBuilder {
	b.Files = append(b.Files, files...)
	return b
}

// AddFile adds a new discord.File to the discord.MessageUpdate
func (b *MessageUpdateBuilder) AddFile(name string, description string, reader io.Reader, flags ...FileFlags) *MessageUpdateBuilder {
	b.Files = append(b.Files, NewFile(name, description, reader, flags...))
	return b
}

// ClearFiles removes all new files of this discord.MessageUpdate
func (b *MessageUpdateBuilder) ClearFiles() *MessageUpdateBuilder {
	b.Files = []*File{}
	return b
}

// RemoveFile removes the new discord.File at this index
func (b *MessageUpdateBuilder) RemoveFile(i int) *MessageUpdateBuilder {
	if len(b.Files) > i {
		b.Files = append(b.Files[:i], b.Files[i+1:]...)
	}
	return b
}

// RetainAttachments removes all Attachment(s) from this Message except the ones provided
func (b *MessageUpdateBuilder) RetainAttachments(attachments ...Attachment) *MessageUpdateBuilder {
	if b.Attachments == nil {
		b.Attachments = new([]AttachmentUpdate)
	}
	for _, attachment := range attachments {
		*b.Attachments = append(*b.Attachments, AttachmentKeep{ID: attachment.ID})
	}
	return b
}

// RetainAttachmentsByID removes all Attachment(s) from this Message except the ones provided
func (b *MessageUpdateBuilder) RetainAttachmentsByID(attachmentIDs ...snowflake.ID) *MessageUpdateBuilder {
	if b.Attachments == nil {
		b.Attachments = new([]AttachmentUpdate)
	}
	for _, attachmentID := range attachmentIDs {
		*b.Attachments = append(*b.Attachments, AttachmentKeep{ID: attachmentID})
	}
	return b
}

// SetAllowedMentions sets the AllowedMentions of the Message
func (b *MessageUpdateBuilder) SetAllowedMentions(allowedMentions *AllowedMentions) *MessageUpdateBuilder {
	b.AllowedMentions = allowedMentions
	return b
}

// ClearAllowedMentions clears the allowed mentions of the Message
func (b *MessageUpdateBuilder) ClearAllowedMentions() *MessageUpdateBuilder {
	return b.SetAllowedMentions(nil)
}

// SetFlags sets the message flags of the Message
func (b *MessageUpdateBuilder) SetFlags(flags MessageFlags) *MessageUpdateBuilder {
	if b.Flags == nil {
		b.Flags = new(MessageFlags)
	}
	*b.Flags = flags
	return b
}

// AddFlags adds the MessageFlags of the Message
func (b *MessageUpdateBuilder) AddFlags(flags ...MessageFlags) *MessageUpdateBuilder {
	if b.Flags == nil {
		b.Flags = new(MessageFlags)
	}
	*b.Flags = b.Flags.Add(flags...)
	return b
}

// RemoveFlags removes the MessageFlags of the Message
func (b *MessageUpdateBuilder) RemoveFlags(flags ...MessageFlags) *MessageUpdateBuilder {
	if b.Flags == nil {
		b.Flags = new(MessageFlags)
	}
	*b.Flags = b.Flags.Remove(flags...)
	return b
}

// ClearFlags clears the MessageFlags of the Message
func (b *MessageUpdateBuilder) ClearFlags() *MessageUpdateBuilder {
	return b.SetFlags(MessageFlagsNone)
}

// SetSuppressEmbeds adds/removes discord.MessageFlagSuppressEmbeds to the Message flags
func (b *MessageUpdateBuilder) SetSuppressEmbeds(suppressEmbeds bool) *MessageUpdateBuilder {
	if b.Flags == nil {
		b.Flags = new(MessageFlags)
	}
	if suppressEmbeds {
		*b.Flags = b.Flags.Add(MessageFlagSuppressEmbeds)
	} else {
		*b.Flags = b.Flags.Remove(MessageFlagSuppressEmbeds)
	}
	return b
}

// Build builds the MessageUpdateBuilder to a MessageUpdate struct
func (b *MessageUpdateBuilder) Build() MessageUpdate {
	return b.MessageUpdate
}
