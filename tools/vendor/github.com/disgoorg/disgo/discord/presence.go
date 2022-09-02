package discord

import (
	"github.com/disgoorg/snowflake/v2"
)

// Presence (https://discord.com/developers/docs/topics/gateway#presence-update)
type Presence struct {
	PresenceUser PresenceUser `json:"user"`
	GuildID      snowflake.ID `json:"guild_id"`
	Status       OnlineStatus `json:"status"`
	Activities   []Activity   `json:"activities"`
	ClientStatus ClientStatus `json:"client_status"`
}

type PresenceUser struct {
	ID snowflake.ID `json:"id"`
}

// OnlineStatus (https://discord.com/developers/docs/topics/gateway#update-presence-status-types)
type OnlineStatus string

const (
	OnlineStatusOnline    OnlineStatus = "online"
	OnlineStatusDND       OnlineStatus = "dnd"
	OnlineStatusIdle      OnlineStatus = "idle"
	OnlineStatusInvisible OnlineStatus = "invisible"
	OnlineStatusOffline   OnlineStatus = "offline"
)

// ClientStatus (https://discord.com/developers/docs/topics/gateway#client-status-object)
type ClientStatus struct {
	Desktop OnlineStatus `json:"desktop,omitempty"`
	Mobile  OnlineStatus `json:"mobile,omitempty"`
	Web     OnlineStatus `json:"web,omitempty"`
}
