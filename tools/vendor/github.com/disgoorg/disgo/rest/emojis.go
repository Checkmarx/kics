package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Emojis = (*emojiImpl)(nil)

func NewEmojis(client Client) Emojis {
	return &emojiImpl{client: client}
}

type Emojis interface {
	GetEmojis(guildID snowflake.ID, opts ...RequestOpt) ([]discord.Emoji, error)
	GetEmoji(guildID snowflake.ID, emojiID snowflake.ID, opts ...RequestOpt) (*discord.Emoji, error)
	CreateEmoji(guildID snowflake.ID, emojiCreate discord.EmojiCreate, opts ...RequestOpt) (*discord.Emoji, error)
	UpdateEmoji(guildID snowflake.ID, emojiID snowflake.ID, emojiUpdate discord.EmojiUpdate, opts ...RequestOpt) (*discord.Emoji, error)
	DeleteEmoji(guildID snowflake.ID, emojiID snowflake.ID, opts ...RequestOpt) error
}

type emojiImpl struct {
	client Client
}

func (s *emojiImpl) GetEmojis(guildID snowflake.ID, opts ...RequestOpt) (emojis []discord.Emoji, err error) {
	err = s.client.Do(GetEmojis.Compile(nil, guildID), nil, &emojis, opts...)
	return
}

func (s *emojiImpl) GetEmoji(guildID snowflake.ID, emojiID snowflake.ID, opts ...RequestOpt) (emoji *discord.Emoji, err error) {
	err = s.client.Do(GetEmoji.Compile(nil, guildID, emojiID), nil, &emoji, opts...)
	return
}

func (s *emojiImpl) CreateEmoji(guildID snowflake.ID, emojiCreate discord.EmojiCreate, opts ...RequestOpt) (emoji *discord.Emoji, err error) {
	err = s.client.Do(CreateEmoji.Compile(nil, guildID), emojiCreate, &emoji, opts...)
	return
}

func (s *emojiImpl) UpdateEmoji(guildID snowflake.ID, emojiID snowflake.ID, emojiUpdate discord.EmojiUpdate, opts ...RequestOpt) (emoji *discord.Emoji, err error) {
	err = s.client.Do(UpdateEmoji.Compile(nil, guildID, emojiID), emojiUpdate, &emoji, opts...)
	return
}

func (s *emojiImpl) DeleteEmoji(guildID snowflake.ID, emojiID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteEmoji.Compile(nil, guildID, emojiID), nil, nil, opts...)
}
