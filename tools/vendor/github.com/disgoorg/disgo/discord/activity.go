package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

// ActivityType represents the status of a user, one of Game, Streaming, Listening, Watching, Custom or Competing
type ActivityType int

// Constants for Activity(s)
const (
	ActivityTypeGame ActivityType = iota
	ActivityTypeStreaming
	ActivityTypeListening
	ActivityTypeWatching
	ActivityTypeCustom
	ActivityTypeCompeting
)

// Activity represents the fields of a user's presence
type Activity struct {
	ID            string              `json:"id"`
	Name          string              `json:"name"`
	Type          ActivityType        `json:"type"`
	URL           *string             `json:"url"`
	CreatedAt     time.Time           `json:"created_at"`
	Timestamps    *ActivityTimestamps `json:"timestamps,omitempty"`
	ApplicationID snowflake.ID        `json:"application_id,omitempty"`
	Details       *string             `json:"details,omitempty"`
	State         *string             `json:"state,omitempty"`
	Emoji         *ActivityEmoji      `json:"emoji,omitempty"`
	Party         *ActivityParty      `json:"party,omitempty"`
	Assets        *ActivityAssets     `json:"assets,omitempty"`
	Secrets       *ActivitySecrets    `json:"secrets,omitempty"`
	Instance      *bool               `json:"instance,omitempty"`
	Flags         ActivityFlags       `json:"flags,omitempty"`
	Buttons       []string            `json:"buttons"`
}

func (a *Activity) UnmarshalJSON(data []byte) error {
	type activity Activity
	var v struct {
		CreatedAt int64 `json:"created_at"`
		activity
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	*a = Activity(v.activity)
	a.CreatedAt = time.UnixMilli(v.CreatedAt)
	return nil
}

func (a Activity) MarshalJSON() ([]byte, error) {
	type activity Activity
	return json.Marshal(struct {
		CreatedAt int64 `json:"created_at"`
		activity
	}{
		CreatedAt: a.CreatedAt.UnixMilli(),
		activity:  (activity)(a),
	})
}

// ActivityFlags add additional information to an activity
type ActivityFlags int

// Discord's supported ActivityFlags
const (
	ActivityFlagInstance ActivityFlags = 1 << iota
	ActivityFlagJoin
	ActivityFlagSpectate
	ActivityFlagJoinRequest
	ActivityFlagSync
	ActivityFlagPlay
	ActivityFlagPartyPrivacyFriends
	ActivityFlagPartyPrivacyVoiceChannel
	ActivityFlagEmbedded
)

// ActivityButton is a button in an activity
type ActivityButton struct {
	Label string `json:"label"`
	URL   string `json:"url"`
}

// ActivityTimestamps represents when a user started and ended their activity
type ActivityTimestamps struct {
	Start time.Time
	End   time.Time
}

func (a *ActivityTimestamps) UnmarshalJSON(data []byte) error {
	var v struct {
		Start int64 `json:"start"`
		End   int64 `json:"end"`
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	a.Start = time.UnixMilli(v.Start)
	a.End = time.UnixMilli(v.End)
	return nil
}

func (a ActivityTimestamps) MarshalJSON() ([]byte, error) {
	return json.Marshal(struct {
		Start int64 `json:"start,omitempty"`
		End   int64 `json:"end,omitempty"`
	}{
		Start: a.Start.UnixMilli(),
		End:   a.End.UnixMilli(),
	})
}

// ActivityEmoji is an Emoji object for an Activity
type ActivityEmoji struct {
	Name     string        `json:"name"`
	ID       *snowflake.ID `json:"id,omitempty"`
	Animated *bool         `json:"animated,omitempty"`
}

// ActivityParty is information about the party of the player
type ActivityParty struct {
	ID   string `json:"id,omitempty"`
	Size []int  `json:"size,omitempty"`
}

// ActivityAssets are the images for the presence and hover texts
type ActivityAssets struct {
	LargeImage string `json:"large_image,omitempty"`
	LargeText  string `json:"large_text,omitempty"`
	SmallImage string `json:"small_image,omitempty"`
	SmallText  string `json:"small_text,omitempty"`
}

// ActivitySecrets contain secrets for Rich Presence joining and spectating
type ActivitySecrets struct {
	Join     string `json:"join,omitempty"`
	Spectate string `json:"spectate,omitempty"`
	Match    string `json:"match,omitempty"`
}
