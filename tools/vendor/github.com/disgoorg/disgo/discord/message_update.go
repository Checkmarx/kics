package discord

// MessageUpdate is used to edit a Message
type MessageUpdate struct {
	Content         *string               `json:"content,omitempty"`
	Embeds          *[]Embed              `json:"embeds,omitempty"`
	Components      *[]ContainerComponent `json:"components,omitempty"`
	Attachments     *[]AttachmentUpdate   `json:"attachments,omitempty"`
	Files           []*File               `json:"-"`
	AllowedMentions *AllowedMentions      `json:"allowed_mentions,omitempty"`
	Flags           *MessageFlags         `json:"flags,omitempty"`
}

func (MessageUpdate) interactionCallbackData() {}

// ToBody returns the MessageUpdate ready for body
func (m MessageUpdate) ToBody() (any, error) {
	if len(m.Files) > 0 {
		for _, attachmentCreate := range parseAttachments(m.Files) {
			if m.Attachments == nil {
				m.Attachments = new([]AttachmentUpdate)
			}
			*m.Attachments = append(*m.Attachments, attachmentCreate)
		}
		return PayloadWithFiles(m, m.Files...)
	}
	return m, nil
}

func (m MessageUpdate) ToResponseBody(response InteractionResponse) (any, error) {
	if len(m.Files) > 0 {
		for _, attachmentCreate := range parseAttachments(m.Files) {
			if m.Attachments == nil {
				m.Attachments = &[]AttachmentUpdate{}
			}
			*m.Attachments = append(*m.Attachments, attachmentCreate)
		}
		return PayloadWithFiles(response, m.Files...)
	}
	return response, nil
}
