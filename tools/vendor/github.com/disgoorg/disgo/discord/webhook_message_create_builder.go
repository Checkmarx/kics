package discord

import (
	"fmt"
	"io"
)

// WebhookMessageCreateBuilder helper to build Message(s) easier
type WebhookMessageCreateBuilder struct {
	WebhookMessageCreate
}

// NewWebhookMessageCreateBuilder creates a new WebhookMessageCreateBuilder to be built later
func NewWebhookMessageCreateBuilder() *WebhookMessageCreateBuilder {
	return &WebhookMessageCreateBuilder{
		WebhookMessageCreate: WebhookMessageCreate{
			AllowedMentions: &DefaultAllowedMentions,
		},
	}
}

// SetContent sets content of the Message
func (b *WebhookMessageCreateBuilder) SetContent(content string) *WebhookMessageCreateBuilder {
	b.Content = content
	return b
}

// SetContentf sets content of the Message
func (b *WebhookMessageCreateBuilder) SetContentf(content string, a ...any) *WebhookMessageCreateBuilder {
	return b.SetContent(fmt.Sprintf(content, a...))
}

func (b *WebhookMessageCreateBuilder) SetUsername(username string) *WebhookMessageCreateBuilder {
	b.Username = username
	return b
}

func (b *WebhookMessageCreateBuilder) SetAvatarURL(url string) *WebhookMessageCreateBuilder {
	b.AvatarURL = url
	return b
}

// SetTTS sets the text to speech of the Message
func (b *WebhookMessageCreateBuilder) SetTTS(tts bool) *WebhookMessageCreateBuilder {
	b.TTS = tts
	return b
}

// SetEmbeds sets the Embed(s) of the Message
func (b *WebhookMessageCreateBuilder) SetEmbeds(embeds ...Embed) *WebhookMessageCreateBuilder {
	b.Embeds = embeds
	return b
}

// SetEmbed sets the provided Embed at the index of the Message
func (b *WebhookMessageCreateBuilder) SetEmbed(i int, embed Embed) *WebhookMessageCreateBuilder {
	if len(b.Embeds) > i {
		b.Embeds[i] = embed
	}
	return b
}

// AddEmbeds adds multiple embeds to the Message
func (b *WebhookMessageCreateBuilder) AddEmbeds(embeds ...Embed) *WebhookMessageCreateBuilder {
	b.Embeds = append(b.Embeds, embeds...)
	return b
}

// ClearEmbeds removes all the embeds from the Message
func (b *WebhookMessageCreateBuilder) ClearEmbeds() *WebhookMessageCreateBuilder {
	b.Embeds = []Embed{}
	return b
}

// RemoveEmbed removes an embed from the Message
func (b *WebhookMessageCreateBuilder) RemoveEmbed(i int) *WebhookMessageCreateBuilder {
	if len(b.Embeds) > i {
		b.Embeds = append(b.Embeds[:i], b.Embeds[i+1:]...)
	}
	return b
}

// SetContainerComponents sets the discord.ContainerComponent(s) of the Message
func (b *WebhookMessageCreateBuilder) SetContainerComponents(containerComponents ...ContainerComponent) *WebhookMessageCreateBuilder {
	b.Components = containerComponents
	return b
}

// SetContainerComponent sets the provided discord.InteractiveComponent at the index of discord.InteractiveComponent(s)
func (b *WebhookMessageCreateBuilder) SetContainerComponent(i int, container ContainerComponent) *WebhookMessageCreateBuilder {
	if len(b.Components) > i {
		b.Components[i] = container
	}
	return b
}

// AddActionRow adds a new discord.ActionRowComponent with the provided discord.InteractiveComponent(s) to the Message
func (b *WebhookMessageCreateBuilder) AddActionRow(components ...InteractiveComponent) *WebhookMessageCreateBuilder {
	b.Components = append(b.Components, ActionRowComponent(components))
	return b
}

// AddContainerComponents adds the discord.ContainerComponent(s) to the Message
func (b *WebhookMessageCreateBuilder) AddContainerComponents(containers ...ContainerComponent) *WebhookMessageCreateBuilder {
	b.Components = append(b.Components, containers...)
	return b
}

// RemoveContainerComponent removes a discord.ActionRowComponent from the Message
func (b *WebhookMessageCreateBuilder) RemoveContainerComponent(i int) *WebhookMessageCreateBuilder {
	if len(b.Components) > i {
		b.Components = append(b.Components[:i], b.Components[i+1:]...)
	}
	return b
}

// ClearContainerComponents removes all the discord.ContainerComponent(s) of the Message
func (b *WebhookMessageCreateBuilder) ClearContainerComponents() *WebhookMessageCreateBuilder {
	b.Components = []ContainerComponent{}
	return b
}

// SetFiles sets the File(s) for this MessageCreate
func (b *WebhookMessageCreateBuilder) SetFiles(files ...*File) *WebhookMessageCreateBuilder {
	b.Files = files
	return b
}

// SetFile sets the discord.File at the index for this discord.MessageCreate
func (b *WebhookMessageCreateBuilder) SetFile(i int, file *File) *WebhookMessageCreateBuilder {
	if len(b.Files) > i {
		b.Files[i] = file
	}
	return b
}

// AddFiles adds the discord.File(s) to the discord.MessageCreate
func (b *WebhookMessageCreateBuilder) AddFiles(files ...*File) *WebhookMessageCreateBuilder {
	b.Files = append(b.Files, files...)
	return b
}

// AddFile adds a discord.File to the discord.MessageCreate
func (b *WebhookMessageCreateBuilder) AddFile(name string, description string, reader io.Reader, flags ...FileFlags) *WebhookMessageCreateBuilder {
	b.Files = append(b.Files, NewFile(name, description, reader, flags...))
	return b
}

// ClearFiles removes all discord.File(s) of this discord.MessageCreate
func (b *WebhookMessageCreateBuilder) ClearFiles() *WebhookMessageCreateBuilder {
	b.Files = []*File{}
	return b
}

// RemoveFile removes the discord.File at this index
func (b *WebhookMessageCreateBuilder) RemoveFile(i int) *WebhookMessageCreateBuilder {
	if len(b.Files) > i {
		b.Files = append(b.Files[:i], b.Files[i+1:]...)
	}
	return b
}

// SetAllowedMentions sets the AllowedMentions of the Message
func (b *WebhookMessageCreateBuilder) SetAllowedMentions(allowedMentions *AllowedMentions) *WebhookMessageCreateBuilder {
	b.AllowedMentions = allowedMentions
	return b
}

// ClearAllowedMentions clears the allowed mentions of the Message
func (b *WebhookMessageCreateBuilder) ClearAllowedMentions() *WebhookMessageCreateBuilder {
	return b.SetAllowedMentions(nil)
}

// SetFlags sets the message flags of the Message
func (b *WebhookMessageCreateBuilder) SetFlags(flags MessageFlags) *WebhookMessageCreateBuilder {
	b.Flags = flags
	return b
}

// AddFlags adds the MessageFlags of the Message
func (b *WebhookMessageCreateBuilder) AddFlags(flags ...MessageFlags) *WebhookMessageCreateBuilder {
	b.Flags = b.Flags.Add(flags...)
	return b
}

// RemoveFlags removes the MessageFlags of the Message
func (b *WebhookMessageCreateBuilder) RemoveFlags(flags ...MessageFlags) *WebhookMessageCreateBuilder {
	b.Flags = b.Flags.Remove(flags...)
	return b
}

// ClearFlags clears the discord.MessageFlags of the Message
func (b *WebhookMessageCreateBuilder) ClearFlags() *WebhookMessageCreateBuilder {
	return b.SetFlags(MessageFlagsNone)
}

// SetSuppressEmbeds adds/removes discord.MessageFlagSuppressEmbeds to the Message flags
func (b *WebhookMessageCreateBuilder) SetSuppressEmbeds(suppressEmbeds bool) *WebhookMessageCreateBuilder {
	if suppressEmbeds {
		b.Flags = b.Flags.Add(MessageFlagSuppressEmbeds)
	} else {
		b.Flags = b.Flags.Remove(MessageFlagSuppressEmbeds)
	}
	return b
}

// SetThreadName sets the thread name the new webhook message should create.
func (b *WebhookMessageCreateBuilder) SetThreadName(threadName string) *WebhookMessageCreateBuilder {
	b.ThreadName = threadName
	return b
}

// Build builds the WebhookMessageCreateBuilder to a MessageCreate struct
func (b *WebhookMessageCreateBuilder) Build() WebhookMessageCreate {
	b.WebhookMessageCreate.Components = b.Components
	return b.WebhookMessageCreate
}
