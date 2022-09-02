package discord

type WebhookMessageCreate struct {
	Content         string               `json:"content,omitempty"`
	Username        string               `json:"username,omitempty"`
	AvatarURL       string               `json:"avatar_url,omitempty"`
	TTS             bool                 `json:"tts,omitempty"`
	Embeds          []Embed              `json:"embeds,omitempty"`
	Components      []ContainerComponent `json:"components,omitempty"`
	Attachments     []AttachmentCreate   `json:"attachments,omitempty"`
	Files           []*File              `json:"-"`
	AllowedMentions *AllowedMentions     `json:"allowed_mentions,omitempty"`
	Flags           MessageFlags         `json:"flags,omitempty"`
	ThreadName      string               `json:"thread_name,omitempty"`
}

// ToBody returns the MessageCreate ready for body
func (m WebhookMessageCreate) ToBody() (any, error) {
	if len(m.Files) > 0 {
		m.Attachments = parseAttachments(m.Files)
		return PayloadWithFiles(m, m.Files...)
	}
	return m, nil
}
