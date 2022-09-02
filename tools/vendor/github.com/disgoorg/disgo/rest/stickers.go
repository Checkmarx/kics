package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Stickers = (*stickerImpl)(nil)

func NewStickers(client Client) Stickers {
	return &stickerImpl{client: client}
}

type Stickers interface {
	GetNitroStickerPacks(opts ...RequestOpt) ([]discord.StickerPack, error)
	GetSticker(stickerID snowflake.ID, opts ...RequestOpt) (*discord.Sticker, error)
	GetStickers(guildID snowflake.ID, opts ...RequestOpt) ([]discord.Sticker, error)
	CreateSticker(guildID snowflake.ID, createSticker discord.StickerCreate, opts ...RequestOpt) (*discord.Sticker, error)
	UpdateSticker(guildID snowflake.ID, stickerID snowflake.ID, stickerUpdate discord.StickerUpdate, opts ...RequestOpt) (*discord.Sticker, error)
	DeleteSticker(guildID snowflake.ID, stickerID snowflake.ID, opts ...RequestOpt) error
}

type stickerImpl struct {
	client Client
}

func (s *stickerImpl) GetNitroStickerPacks(opts ...RequestOpt) (stickerPacks []discord.StickerPack, err error) {
	var stickerPacksRs discord.StickerPacks
	err = s.client.Do(GetNitroStickerPacks.Compile(nil), nil, &stickerPacksRs, opts...)
	if err == nil {
		stickerPacks = stickerPacksRs.StickerPacks
	}
	return
}

func (s *stickerImpl) GetSticker(stickerID snowflake.ID, opts ...RequestOpt) (sticker *discord.Sticker, err error) {
	err = s.client.Do(GetSticker.Compile(nil, stickerID), nil, &sticker, opts...)
	return
}

func (s *stickerImpl) GetStickers(guildID snowflake.ID, opts ...RequestOpt) (stickers []discord.Sticker, err error) {
	err = s.client.Do(GetGuildStickers.Compile(nil, guildID), nil, &stickers, opts...)
	return
}

func (s *stickerImpl) CreateSticker(guildID snowflake.ID, createSticker discord.StickerCreate, opts ...RequestOpt) (sticker *discord.Sticker, err error) {
	body, err := createSticker.ToBody()
	if err != nil {
		return
	}
	err = s.client.Do(CreateGuildSticker.Compile(nil, guildID), body, &sticker, opts...)
	return
}

func (s *stickerImpl) UpdateSticker(guildID snowflake.ID, stickerID snowflake.ID, stickerUpdate discord.StickerUpdate, opts ...RequestOpt) (sticker *discord.Sticker, err error) {
	err = s.client.Do(UpdateGuildSticker.Compile(nil, guildID, stickerID), stickerUpdate, &sticker, opts...)
	return
}

func (s *stickerImpl) DeleteSticker(guildID snowflake.ID, stickerID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteGuildSticker.Compile(nil, guildID, stickerID), nil, nil, opts...)
}
