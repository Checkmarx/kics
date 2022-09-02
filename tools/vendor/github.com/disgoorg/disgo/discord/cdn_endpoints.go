package discord

import (
	"strings"
)

const CDN = "https://cdn.discordapp.com"

var (
	CustomEmoji = NewCDN("/emojis/{emote.id}", ImageFormatPNG, ImageFormatGIF)

	GuildIcon            = NewCDN("/icons/{guild.id}/{guild.icon.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP, ImageFormatGIF)
	GuildSplash          = NewCDN("/splashes/{guild.id}/{guild.splash.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)
	GuildDiscoverySplash = NewCDN("/discovery-splashes/{guild.id}/{guild.discovery.splash.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)
	GuildBanner          = NewCDN("/banners/{guild.id}/{guild.banner.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP, ImageFormatGIF)

	RoleIcon = NewCDN("/role-icons/{role.id}/{role.icon.hash}", ImageFormatPNG, ImageFormatJPEG)

	UserBanner        = NewCDN("/banners/{user.id}/{user.banner.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP, ImageFormatGIF)
	UserAvatar        = NewCDN("/avatars/{user.id}/{user.avatar.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP, ImageFormatGIF)
	DefaultUserAvatar = NewCDN("/embed/avatars/{user.discriminator%5}", ImageFormatPNG)

	ChannelIcon = NewCDN("/channel-icons/{channel.id}/{channel.icon.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)

	MemberAvatar = NewCDN("/guilds/{guild.id}/users/{user.id}/avatars/{member.avatar.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP, ImageFormatGIF)

	ApplicationIcon  = NewCDN("/app-icons/{application.id}/{icon.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)
	ApplicationCover = NewCDN("/app-assets/{application.id}/{cover.image.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)
	ApplicationAsset = NewCDN("/app-assets/{application.id}/{asset.id}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)

	AchievementIcon = NewCDN("/app-assets/{application.id}/achievements/{achievement.id}/icons/{icon.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)

	TeamIcon = NewCDN("/team-icons/{team.id}/{team.icon.hash}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)

	StickerPackBanner = NewCDN("app-assets/710982414301790216/store/{banner.asset.id}", ImageFormatPNG, ImageFormatJPEG, ImageFormatWebP)
	CustomSticker     = NewCDN("/stickers/{sticker.id}", ImageFormatPNG, ImageFormatLottie)

	AttachmentFile = NewCDN("/attachments/{channel.id}/{attachment.id}/{file.name}", ImageFormatNone)
)

// ImageFormat is the type of image on Discord's CDN (https://discord.com/developers/docs/reference#image-formatting-image-formats)
type ImageFormat string

// The available ImageFormat(s)
const (
	ImageFormatNone   ImageFormat = ""
	ImageFormatPNG    ImageFormat = "png"
	ImageFormatJPEG   ImageFormat = "jpg"
	ImageFormatWebP   ImageFormat = "webp"
	ImageFormatGIF    ImageFormat = "gif"
	ImageFormatLottie ImageFormat = "json"
)

// String returns the string representation of the ImageFormat
func (f ImageFormat) String() string {
	return string(f)
}

// Animated returns true if the ImageFormat is animated
func (f ImageFormat) Animated() bool {
	switch f {
	case ImageFormatWebP, ImageFormatGIF:
		return true
	default:
		return false
	}
}

func NewCDN(route string, imageFormats ...ImageFormat) *CDNEndpoint {
	return &CDNEndpoint{
		Route:   route,
		Formats: imageFormats,
	}
}

type CDNEndpoint struct {
	Route   string
	Formats []ImageFormat
}

func (e CDNEndpoint) URL(format ImageFormat, values QueryValues, params ...any) string {
	query := values.Encode()
	if query != "" {
		query = "?" + query
	}
	return urlPrint(CDN+e.Route+"."+format.String(), params...) + query
}

func DefaultCDNConfig() *CDNConfig {
	return &CDNConfig{
		Format: ImageFormatPNG,
		Values: QueryValues{},
	}
}

type CDNConfig struct {
	Format ImageFormat
	Values QueryValues
}

// Apply applies the given ConfigOpt(s) to the Config
func (c *CDNConfig) Apply(opts []CDNOpt) {
	for _, opt := range opts {
		opt(c)
	}
}

type CDNOpt func(config *CDNConfig)

func WithSize(size int) CDNOpt {
	return func(config *CDNConfig) {
		config.Values["size"] = size
	}
}

func WithFormat(format ImageFormat) CDNOpt {
	return func(config *CDNConfig) {
		config.Format = format
	}
}

func formatAssetURL(cdnRoute *CDNEndpoint, opts []CDNOpt, params ...any) string {
	config := DefaultCDNConfig()
	config.Apply(opts)

	var lastStringParam string
	lastParam := params[len(params)-1]
	if str, ok := lastParam.(string); ok {
		if str == "" {
			return ""
		}
		lastStringParam = str
	} else if ptrStr, ok := lastParam.(*string); ok {
		if ptrStr == nil {
			return ""
		}
		lastStringParam = *ptrStr
	}

	if strings.HasPrefix(lastStringParam, "a_") && !config.Format.Animated() {
		config.Format = ImageFormatGIF
	}

	return cdnRoute.URL(config.Format, config.Values, params...)
}
