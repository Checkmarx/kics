package discord

import (
	"errors"
)

var (
	ErrNoGatewayOrShardManager = errors.New("no gateway or shard manager configured")
	ErrNoGuildMembersIntent    = errors.New("this operation requires the GUILD_MEMBERS intent")
	ErrNoShardManager          = errors.New("no shard manager configured")
	ErrNoGateway               = errors.New("no gateway configured")
	ErrGatewayAlreadyConnected = errors.New("gateway is already connected")
	ErrShardNotConnected       = errors.New("shard is not connected")
	ErrShardNotFound           = errors.New("shard not found in shard manager")
	ErrGatewayCompressedData   = errors.New("disgo does not currently support compressed gateway data")
	ErrNoHTTPServer            = errors.New("no http server configured")

	ErrNoDisgoInstance = errors.New("no disgo instance injected")

	ErrInvalidBotToken = errors.New("token is not in a valid format")
	ErrNoBotToken      = errors.New("please specify the token")

	ErrSelfDM = errors.New("can't open a dm channel to yourself")

	ErrInteractionAlreadyReplied = errors.New("you already replied to this interaction")
	ErrInteractionExpired        = errors.New("this interaction has expired")

	ErrChannelNotTypeNews = errors.New("channel type is not 'NEWS'")

	ErrCheckFailed = errors.New("check failed")

	ErrMemberMustBeConnectedToChannel = errors.New("the member must be connected to the channel")

	ErrStickerTypeGuild = errors.New("sticker type must be of type StickerTypeGuild")
)
