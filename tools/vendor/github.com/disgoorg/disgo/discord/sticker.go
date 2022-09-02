package discord

import (
	"time"

	"github.com/disgoorg/snowflake/v2"
)

// Sticker is a sticker sent with a Message
type Sticker struct {
	ID          snowflake.ID      `json:"id"`
	PackID      *snowflake.ID     `json:"pack_id"`
	Name        string            `json:"name"`
	Description string            `json:"description"`
	Tags        string            `json:"tags"`
	Type        StickerType       `json:"type"`
	FormatType  StickerFormatType `json:"format_type"`
	Available   *bool             `json:"available"`
	GuildID     *snowflake.ID     `json:"guild_id,omitempty"`
	User        *User             `json:"user,omitempty"`
	SortValue   *int              `json:"sort_value"`
}

func (s Sticker) URL(opts ...CDNOpt) string {
	format := ImageFormatPNG
	if s.FormatType == StickerFormatTypeLottie {
		format = ImageFormatLottie
	}
	return formatAssetURL(CustomSticker, append(opts, WithFormat(format)), s.ID)
}

func (s Sticker) CreatedAt() time.Time {
	return s.ID.Time()
}

type StickerType int

const (
	StickerTypeStandard StickerType = iota + 1
	StickerTypeGuild
)

// StickerFormatType is the Format type of Sticker
type StickerFormatType int

// Constants for StickerFormatType
const (
	StickerFormatTypePNG StickerFormatType = iota + 1
	StickerFormatTypeAPNG
	StickerFormatTypeLottie
)

type StickerCreate struct {
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
	Tags        string `json:"tags"`
	File        *File  `json:"-"`
}

// ToBody returns the MessageCreate ready for body
func (c StickerCreate) ToBody() (any, error) {
	if c.File != nil {
		return PayloadWithFiles(c, c.File)
	}
	return c, nil
}

type StickerUpdate struct {
	Name        *string `json:"name,omitempty"`
	Description *string `json:"description,omitempty"`
	Tags        *string `json:"tags,omitempty"`
}

type StickerPack struct {
	ID             snowflake.ID  `json:"id"`
	Stickers       []Sticker     `json:"stickers"`
	Name           string        `json:"name"`
	SkuID          snowflake.ID  `json:"sku_id"`
	CoverStickerID snowflake.ID  `json:"cover_sticker_id"`
	Description    string        `json:"description"`
	BannerAssetID  *snowflake.ID `json:"banner_asset_id"`
}

func (p StickerPack) BannerURL(opts ...CDNOpt) *string {
	if p.BannerAssetID == nil {
		return nil
	}
	url := formatAssetURL(StickerPackBanner, opts, p.BannerAssetID)
	return &url
}

type StickerPacks struct {
	StickerPacks []StickerPack `json:"sticker_packs"`
}
