package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

type BaseInteraction interface {
	ID() snowflake.ID
	ApplicationID() snowflake.ID
	Token() string
	Version() int
	GuildID() *snowflake.ID
	ChannelID() snowflake.ID
	Locale() Locale
	GuildLocale() *Locale
	Member() *ResolvedMember
	User() User
	AppPermissions() *Permissions
	CreatedAt() time.Time
}

type baseInteractionImpl struct {
	id             snowflake.ID
	applicationID  snowflake.ID
	token          string
	version        int
	guildID        *snowflake.ID
	channelID      snowflake.ID
	locale         Locale
	guildLocale    *Locale
	member         *ResolvedMember
	user           *User
	appPermissions *Permissions
}

func (i *baseInteractionImpl) UnmarshalJSON(data []byte) error {
	var v rawInteraction
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}
	i.id = v.ID
	i.applicationID = v.ApplicationID
	i.token = v.Token
	i.version = v.Version
	i.guildID = v.GuildID
	i.channelID = v.ChannelID
	i.locale = v.Locale
	i.guildLocale = v.GuildLocale
	i.member = v.Member
	i.user = v.User
	i.appPermissions = v.AppPermissions
	return nil
}

func (i baseInteractionImpl) MarshalJSON() ([]byte, error) {
	return json.Marshal(rawInteraction{
		ID:             i.id,
		ApplicationID:  i.applicationID,
		Token:          i.token,
		Version:        i.version,
		GuildID:        i.guildID,
		ChannelID:      i.channelID,
		Locale:         i.locale,
		GuildLocale:    i.guildLocale,
		Member:         i.member,
		User:           i.user,
		AppPermissions: i.appPermissions,
	})
}

func (i baseInteractionImpl) ID() snowflake.ID {
	return i.id
}
func (i baseInteractionImpl) ApplicationID() snowflake.ID {
	return i.applicationID
}
func (i baseInteractionImpl) Token() string {
	return i.token
}
func (i baseInteractionImpl) Version() int {
	return i.version
}
func (i baseInteractionImpl) GuildID() *snowflake.ID {
	return i.guildID
}
func (i baseInteractionImpl) ChannelID() snowflake.ID {
	return i.channelID
}
func (i baseInteractionImpl) Locale() Locale {
	return i.locale
}
func (i baseInteractionImpl) GuildLocale() *Locale {
	return i.guildLocale
}
func (i baseInteractionImpl) Member() *ResolvedMember {
	return i.member
}
func (i baseInteractionImpl) User() User {
	if i.user != nil {
		return *i.user
	}
	return i.member.User
}

func (i baseInteractionImpl) AppPermissions() *Permissions {
	return i.appPermissions
}

func (i baseInteractionImpl) CreatedAt() time.Time {
	return i.id.Time()
}
