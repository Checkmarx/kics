package api

import (
	"strconv"
	"strings"

	"github.com/DisgoOrg/restclient"
)

// User represents a Discord User
type User struct {
	ID            string  `json:"id"`
	Discriminator string  `json:"discriminator"`
	Bot           bool    `json:"bot"`
	Username      string  `json:"username"`
	Avatar        *string `json:"avatar"`
}

// Mention returns the user as a mention
func (u User) Mention() string {
	return "<@" + u.ID + ">"
}

// Tag returns the user's Username and Discriminator
func (u User) Tag() string {
	return u.Username + "#" + u.Discriminator
}

// String returns
func (u User) String() string {
	return u.Mention()
}

// AvatarURL returns the Icon of a User
func (u *User) AvatarURL(size int) string {
	if u.Avatar == nil {
		discrim, _ := strconv.Atoi(u.Discriminator)
		route, err := restclient.DefaultUserAvatar.Compile(nil, restclient.PNG, size, discrim%5)
		if err != nil {
			return ""
		}
		return route.Route()
	}
	format := restclient.PNG
	if strings.HasPrefix(*u.Avatar, "a_") {
		format = restclient.GIF
	}
	route, err := restclient.UserAvatar.Compile(nil, format, size, u.ID, *u.Avatar)
	if err != nil {
		return ""
	}
	return route.Route()
}
