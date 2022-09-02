package discord

import (
	"github.com/disgoorg/snowflake/v2"
)

// MessageCreate is the struct to create a new Message with
type MessageCreate struct {
	Nonce            string               `json:"nonce,omitempty"`
	Content          string               `json:"content,omitempty"`
	TTS              bool                 `json:"tts,omitempty"`
	Embeds           []Embed              `json:"embeds,omitempty"`
	Components       []ContainerComponent `json:"components,omitempty"`
	StickerIDs       []snowflake.ID       `json:"sticker_ids,omitempty"`
	Files            []*File              `json:"-"`
	Attachments      []AttachmentCreate   `json:"attachments,omitempty"`
	AllowedMentions  *AllowedMentions     `json:"allowed_mentions,omitempty"`
	MessageReference *MessageReference    `json:"message_reference,omitempty"`
	Flags            MessageFlags         `json:"flags,omitempty"`
}

func (MessageCreate) interactionCallbackData() {}

// ToBody returns the MessageCreate ready for body
func (m MessageCreate) ToBody() (any, error) {
	if len(m.Files) > 0 {
		m.Attachments = parseAttachments(m.Files)
		return PayloadWithFiles(m, m.Files...)
	}
	return m, nil
}

func (m MessageCreate) ToResponseBody(response InteractionResponse) (any, error) {
	if len(m.Files) > 0 {
		m.Attachments = parseAttachments(m.Files)
		response.Data = m
		return PayloadWithFiles(response, m.Files...)
	}
	return response, nil
}
