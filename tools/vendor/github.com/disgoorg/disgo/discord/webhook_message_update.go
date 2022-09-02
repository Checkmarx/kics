package discord

// WebhookMessageUpdate is used to edit a Message
type WebhookMessageUpdate struct {
	Content         *string               `json:"content,omitempty"`
	Embeds          *[]Embed              `json:"embeds,omitempty"`
	Components      *[]ContainerComponent `json:"components,omitempty"`
	Attachments     *[]AttachmentUpdate   `json:"attachments,omitempty"`
	Files           []*File               `json:"-"`
	AllowedMentions *AllowedMentions      `json:"allowed_mentions,omitempty"`
}

// ToBody returns the WebhookMessageUpdate ready for body
func (m WebhookMessageUpdate) ToBody() (any, error) {
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
