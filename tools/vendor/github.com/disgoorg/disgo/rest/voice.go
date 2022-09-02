package rest

import (
	"github.com/disgoorg/disgo/discord"
)

var _ Voice = (*voiceImpl)(nil)

func NewVoice(client Client) Voice {
	return &voiceImpl{client: client}
}

type Voice interface {
	GetVoiceRegions(opts ...RequestOpt) ([]discord.VoiceRegion, error)
}

type voiceImpl struct {
	client Client
}

func (s *voiceImpl) GetVoiceRegions(opts ...RequestOpt) (regions []discord.VoiceRegion, err error) {
	err = s.client.Do(GetVoiceRegions.Compile(nil), nil, &regions, opts...)
	return
}
