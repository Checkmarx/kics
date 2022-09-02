package discord

type Connection struct {
	ID           string         `json:"id"`
	Name         string         `json:"name"`
	Type         ConnectionType `json:"type"`
	Revoked      bool           `json:"revoked,omitempty"`
	Integrations []Integration  `json:"integrations,omitempty"`
	Verified     bool           `json:"verified"`
	FriendSync   bool           `json:"friend_sync"`
	ShowActivity bool           `json:"show_activity"`
	Visibility   VisibilityType `json:"visibility"`
}

type ConnectionType string

const (
	ConnectionTypeYouTube   ConnectionType = "youtube"
	ConnectionTypeBattleNet ConnectionType = "battlenet"
	ConnectionTypeGitHub    ConnectionType = "github"
	ConnectionTypeReddit    ConnectionType = "reddit"
	ConnectionTypeSpotify   ConnectionType = "spotify"
	ConnectionTypeSteam     ConnectionType = "steam"
	ConnectionTypeTwitch    ConnectionType = "twitch"
	ConnectionTypeTwitter   ConnectionType = "twitter"
	ConnectionTypeXBox      ConnectionType = "xbox"
	ConnectionTypeFacebook  ConnectionType = "facebook"
)

type VisibilityType int

const (
	VisibilityTypeNone VisibilityType = iota
	VisibilityTypeEveryone
)
